# Class: icinga::skel
#
# Some extra stuff necessary for Example42 icinga implementation
# Needed to make things go smoothly
#
# Usage:
# Autoincluded by icinga class
#
class icinga::skel {

  include icinga

  file { 'icinga_configdir':
    ensure  => directory,
    path    => $icinga::customconfigdir,
    mode    => '0755',
    owner   => $icinga::config_file_owner,
    group   => $icinga::config_file_group,
    require => Package['icinga'],
  }

  file { 'icinga_configdir_hosts':
    ensure  => directory,
    path    => "${icinga::customconfigdir}/hosts",
    mode    => '0755',
    owner   => $icinga::config_file_owner,
    group   => $icinga::config_file_group,
    require => File['icinga_configdir'],
    recurse => true,
    purge   => true,
    force   => true,
  }

  file { 'icinga_configdir_services':
    ensure  => directory,
    path    => "${icinga::customconfigdir}/services",
    mode    => '0755',
    owner   => $icinga::config_file_owner,
    group   => $icinga::config_file_group,
    require => File['icinga_configdir'],
    recurse => true,
    purge   => true,
    force   => true,
  }

  file { 'icinga_configdir_commands':
    ensure  => directory,
    path    => "${icinga::customconfigdir}/commands",
    mode    => '0755',
    owner   => $icinga::config_file_owner,
    group   => $icinga::config_file_group,
    require => File['icinga_configdir'],
  }

  file { 'icinga_configdir_settings':
    ensure  => directory,
    path    => "${icinga::customconfigdir}/settings",
    mode    => '0755',
    owner   => $icinga::config_file_owner,
    group   => $icinga::config_file_group,
    require => File['icinga_configdir'],
  }

  file { 'icinga_configdir_hostgroups':
    ensure  => directory,
    path    => "${icinga::customconfigdir}/hostgroups",
    mode    => '0755',
    owner   => $icinga::config_file_owner,
    group   => $icinga::config_file_group,
    require => File['icinga_configdir'],
  }

  file { 'icinga_configdir_extra':
    ensure  => directory,
    path    => "${icinga::customconfigdir}/extra",
    mode    => '0755',
    owner   => $icinga::config_file_owner,
    group   => $icinga::config_file_group,
    require => File['icinga_configdir'],
    source  => $icinga::extra_dir_source,
    recurse => true,
  }


  file { 'icinga_modulesdir':
    ensure  => directory,
    path    => "${icinga::config_dir}/modules",
    mode    => '0755',
    owner   => $icinga::config_file_owner,
    group   => $icinga::config_file_group,
    require => File['icinga_configdir'],
  }

  # Basic configurations
  file { 'icinga_commands_general.cfg':
    ensure  => $icinga::manage_file,
    path    => "${icinga::customconfigdir}/commands/general.cfg",
    mode    => '0644',
    owner   => $icinga::config_file_owner,
    group   => $icinga::config_file_group,
    require => File['icinga_configdir_commands'],
    content => template($icinga::template_commands_general),
  }

  file { 'icinga_commands_extra.cfg':
    ensure  => $icinga::manage_file,
    path    => "${icinga::customconfigdir}/commands/extra.cfg",
    mode    => '0644',
    owner   => $icinga::config_file_owner,
    group   => $icinga::config_file_group,
    require => File['icinga_configdir_commands'],
    content => template($icinga::template_commands_extra),
  }

  file { 'icinga_commands_special.cfg':
    ensure  => $icinga::manage_file,
    path    => "${icinga::customconfigdir}/commands/special.cfg",
    mode    => '0644',
    owner   => $icinga::config_file_owner,
    group   => $icinga::config_file_group,
    require => File['icinga_configdir_commands'],
    content => template($icinga::template_commands_special),
  }

  file { 'icinga_contacts.cfg':
    ensure  => $icinga::manage_file,
    path    => "${icinga::customconfigdir}/settings/contacts.cfg",
    mode    => '0644',
    owner   => $icinga::config_file_owner,
    group   => $icinga::config_file_group,
    require => File['icinga_configdir_settings'],
    content => template($icinga::template_settings_contacts),
  }

  file { 'icinga_timeperiods.cfg':
    ensure  => $icinga::manage_file,
    path    => "${icinga::customconfigdir}/settings/timeperiods.cfg",
    mode    => '0644',
    owner   => $icinga::config_file_owner,
    group   => $icinga::config_file_group,
    require => File['icinga_configdir_settings'],
    content => template($icinga::template_settings_timeperiods),
  }

  file { 'icinga_templates.cfg':
    ensure  => $icinga::manage_file,
    path    => "${icinga::customconfigdir}/settings/templates.cfg",
    mode    => '0644',
    owner   => $icinga::config_file_owner,
    group   => $icinga::config_file_group,
    require => File['icinga_configdir_settings'],
    content => template($icinga::template_settings_templates),
  }

  $alldefault_ensure = $::icinga_hostgrouplogic ? {
    ''      => present,
    default => present,
  }

  file { 'icinga_hostgroup_alldefault.cfg':
    ensure  => $alldefault_ensure,
    path    => "${icinga::customconfigdir}/hostgroups/alldefault.cfg",
    mode    => '0644',
    owner   => $icinga::config_file_owner,
    group   => $icinga::config_file_group,
    require => File['icinga_configdir_hostgroups'],
    content => template($icinga::template_hostgroups_all),
  }

  # Htpasswd file (Defaultuser icingaadmin:example42)
  file { 'icinga_htpasswd':
    ensure  => $icinga::manage_file,
    path    => $icinga::htpasswdfile,
    mode    => '0644',
    owner   => $icinga::config_file_owner,
    group   => $icinga::config_file_group,
    content => template($icinga::template_htpasswdfile),
    require => Package['icinga'],
  }

  # icinga group needs permission to write in /var/lib/icinga/rw
  if $::operatingsystem =~ /(?i:Debian|Ubuntu|Mint)/ {
    @file { '/var/lib/icinga/rw':
      ensure  => directory,
      mode    => '0770',
      owner   => $icinga::process_user,
      group   => $icinga::process_user,
      require => Package['icinga'],
    }

    realize ( File['/var/lib/icinga/rw'] )
  }

}
