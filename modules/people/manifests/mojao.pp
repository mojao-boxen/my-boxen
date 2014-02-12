class people::mojao {
  #
  # osx
  #

  # Finder
  include osx::finder::unhide_library
  include osx::finder::show_hidden_files

  # Dock
  include osx::dock::autohide
  include osx::finder::enable_quicklook_text_selection
  class osx::dock::kill_dashbord{
    include osx::dock
    boxen::osx_defaults { 'kill dashbord':
      user   => $::boxen_user,
      domain => 'com.apple.dashboard',
      key    => 'mcx-disabled',
      value  => YES,
      notify => Exec['killall Dock'];
    }
  }
  include osx::dock::kill_dashbord

  # Universal Access
  include osx::universal_access::ctrl_mod_zoom
  include osx::universal_access::enable_scrollwheel_zoom

  # Miscellaneous
  include osx::no_network_dsstores # disable creation of .DS_Store files on network shares
  include osx::software_update # download and install software updates

  # keybord
  include osx::keyboard::capslock_to_control
  include osx::global::key_repeat_delay

  #
  # lib
  #

  homebrew::tap { 'homebrew/binary': }
  package {
    [
      'readline',                   # use for ruby compile
      'tree',                       # linux tree cmd
      'z',                          # shortcut change dir
      'the_silver_searcher',        # alternative grep
      'proctools',                  # kill by process name. like $ pkill firefox
      'gitx'                        # git gui client
    ]:
  }

  include java
  include mysql
  include redis
  include wget
  include zsh
  include imagemagick
  include phantomjs
  include mongodb
  include memcached
  phantomjs::version { '1.9.2': }

  # zsh
  package {
    'zsh':
      install_options => [
        '--disable-etcdir'
      ]
  }
  file_line { 'add zsh to /etc/shells':
    path    => '/etc/shells',
    line    => "${boxen::config::homebrewdir}/bin/zsh",
    require => Package['zsh'],
    before  => Osx_chsh[$::luser];
  }
  osx_chsh { $::luser:
    shell   => "${boxen::config::homebrewdir}/bin/zsh";
  }

  #
  # local application for develop
  #
  include sequel_pro
  include virtualbox
  include vagrant
  include iterm2::stable
  include firefox
  include chrome


  #
  # local application for utility
  #
  include dropbox
  include skype
  include hipchat
  include alfred
  include evernote
  include keyremap4macbook
}
