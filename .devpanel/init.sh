#!/bin/bash
# ---------------------------------------------------------------------
# Copyright (C) 2024 DevPanel
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation version 3 of the
# License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# For GNU Affero General Public License see <https://www.gnu.org/licenses/>.
# ----------------------------------------------------------------------

#== Clone source code
cd $APP_ROOT;
SETTINGS_FILES_PATH=$WEB_ROOT/sites/default/settings.php
if [ ! -d "$APP_ROOT/drupal_cms" ]; then
  git submodule update --init --remote --recursive
fi
exit
sudo composer self-update --2

#== Composer install.
cd $APP_ROOT/drupal_cms

#== Site install.
if [[ $(mysql -h$DB_HOST -P$DB_PORT -u$DB_USER -p$DB_PASSWORD $DB_NAME -e "show tables;") == '' ]]; then
  drush si --account-name=devpanel --account-pass=devpanel  --site-name="Drupal CMS" --db-url=mysql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME -y
  #== Setup settings.php file
  echo "Setup settings.php file"
  # sudo cp $APP_ROOT/.devpanel/drupal-settings.php $SETTINGS_FILES_PATH
  # chmod u-w $SETTINGS_FILES_PATH
  drush cr

  #== Webform library install.
  drush webform-libraries-download
fi
