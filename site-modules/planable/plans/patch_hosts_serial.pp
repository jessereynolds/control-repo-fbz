# Patch hosts including suspending monitoring alerts and email notification on completion
plan planable::patch_hosts_serial (
  TargetSpec    $targets,
  Boolean       $always_reboot      = false,
  Integer       $post_reboot_sleep  = 1,
  String        $solarwinds_proxy   = 'solarwinds.example',
  String        $email_proxy        = 'smtp.example',
  String        $patching_plan_name = 'patch hosts parallel',
  Array[String] $email_recipients   = ['example@example'],
  String        $email_sender       = 'example@example',
) {
  out::message('Commencing plan')
  out::message("Targets: ${targets}")

  # verify certnames - TODO: break out to a utility plan
  $nodes = $targets.map |$target| {
    $nr = puppetdb_query("
      nodes[certname] { 
        certname ~ '^${target}'
      }
    ")
    unless $nr =~ Array[Hash, 1] {
      fail_plan("hostname cannot be found in puppetdb: ${target}", 'planable/no_node_error')
    }
    $node = $nr[0]['certname']
    assert_type(String[1], $node)
  }

  $hostname_array = $nodes.map |$node| {
    $node.split(/\./)[0].downcase
  }

  # loop over all targets
  $results = get_targets($nodes).map |$target| {
    $hostname = $target.host.split(/\./)[0].downcase

    # disable alerts
    out::message('Disabling alerting...')
    $disable_alerting_result = run_task('planable::monitoring_solarwinds', $solarwinds_proxy, {
      'targets'       => [$hostname],
      'action'        => 'disable',
      'name_property' => 'NodeName',
      '_catch_errors' => true,
    }).first

    unless $disable_alerting_result.ok {
      out::message("Error disabling alerting for ${hostname}, skipping patching")
      next($disable_alerting_result)
    }

    out::message("Applying patches on ${target.host} with reboot=never ...")
    $patch_result = run_task('pe_patch::patch_server', get_target($target), {
      'reboot'        => 'never',
      '_catch_errors' => true,
    }).first

    unless $patch_result.ok {
      out::message("Error applying patches on ${hostname}")
      next($patch_result)
    }

    # refresh the pe_patch fact
    $refresh_fact_result = run_task('pe_patch::refresh_fact', get_target($target), {'_catch_errors' => true}).first
    unless $refresh_fact_result.ok {
      out::message("Error refreshing pe_patch facts for ${hostname}")
      next($refresh_fact_result)
    }

    $pe_patch_fact_result = run_task('facter_task', get_target($target), {'fact' => 'pe_patch', '_catch_errors' => true}).first
    unless $pe_patch_fact_result.ok {
      out::message("Error obtaining pe_patch fact for ${hostname}")
      next($pe_patch_fact_result)
    }
    $pe_patch_fact = $pe_patch_fact_result['pe_patch']

    # If a reboot is pending then reboot (even if no patches were applied)
    if $pe_patch_fact['reboots']['reboot_required'] == true or $pe_patch_fact['reboots']['reboot_required'] == 'true' or $always_reboot {
      $reboot_results = run_plan('reboot', {
        'targets'             => get_target($target),
        'message'             => 'planable puppet plan is rebooting this server',
        'reboot_delay'        => 30,
        'disconnect_wait'     => 30,
        'reconnect_timeout'   => 900,
        'retry_interval'      => 15,
        'fail_plan_on_errors' => false,
        '_catch_errors'       => true,
      })
      if $reboot_results =~ ResultSet {
        $reboot_result = $reboot_results.first
        unless $reboot_result.ok {
          out::message("Error rebooting ${hostname}")
          next($reboot_result)
        }
      } else {
        out::message("Error: unexpected result data type from the reboot plan, expected ResultSet, got ${type($reboot_results)}")
        next($reboot_results)
      }

      out::message("Sleeping post reboot for ${post_reboot_sleep} seconds")
      reboot::sleep($post_reboot_sleep)
    }
    $patch_result
  }

  # enable alerts
  out::message('Enabling alerting...')
  $alerts_enable_results = run_task('planable::monitoring_solarwinds', $solarwinds_proxy, {
    'targets'       => $hostname_array,
    'action'        => 'enable',
    'name_property' => 'NodeName',
    '_catch_errors' => true,
  })
  unless $alerts_enable_results.ok {
    out::message("Error enabling alerting on some targets: ${$alerts_enable_results.error_set.names}")
  }

  # send email notification
  out::message('Sending email notification...')
  $message = epp('planable/email_report.epp', {
    'patch_results' => $results,
    'ok_set'        => $results.filter |$result| { $result.to_data['status'] == 'success' },
    'error_set'     => $results.filter |$result| { $result.to_data['status'] != 'success' },
  })

  $email_send_results = run_task('profile::send_email', $email_proxy, {
    'sender'        => $email_sender,
    'recipients'    => $email_recipients,
    'subject'       => "planable patching - ${patching_plan_name} serial",
    'body'          => $message,
    '_catch_errors' => true,
  })

}
