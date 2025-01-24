# class to demonstrate parameter lookups and defaults from hiera
# called by profile::test_agent
class test_agent (
  Boolean                   $option_1,
  Enum['public', 'private'] $option_2,
  String                    $option_3,
) {

  notify { "test_agent option_1: ${option_1}": }
  notify { "test_agent option_2: ${option_2}": }
  notify { "test_agent option_3: ${option_3}": }

}
