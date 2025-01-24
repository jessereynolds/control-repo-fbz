# test parameters starting with underscore
class profile::underscore_param (
  String $_bar = 'underscore_bar',
) {
  notify { $_bar: }
}
