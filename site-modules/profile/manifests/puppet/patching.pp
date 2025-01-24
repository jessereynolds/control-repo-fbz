class profile::puppet::patching (
  $patch_group      = undef,
  $blackout_windows = undef,
  $reboot_override  = undef,
) {
  # Call the pe_patch class to set everything up
  class { 'pe_patch':
    patch_group      => $patch_group,
    reboot_override  => $reboot_override,
    blackout_windows => $full_blackout_windows,
  }
}
