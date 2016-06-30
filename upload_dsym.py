"""
Python script that zips and uploads a dSYM file package to Rollbar
during an iOS app's build process.

For instructions on setting up this script for your app in Xcode, see
the README at https://github.com/rollbar/rollbar-ios/blob/master/README.md.
"""

import os
import subprocess
import zipfile

if (os.environ['DEBUG_INFORMATION_FORMAT'] != 'dwarf-with-dsym' or
        os.environ['EFFECTIVE_PLATFORM_NAME'] == '-iphonesimulator'):
    exit(0)

ACCESS_TOKEN = 'POST_SERVER_ITEM_ACCESS_TOKEN'

dsym_file_path = os.path.join(os.environ['DWARF_DSYM_FOLDER_PATH'],
                              os.environ['DWARF_DSYM_FILE_NAME'])
zip_location = '%s.zip' % (dsym_file_path)

os.chdir(os.environ['DWARF_DSYM_FOLDER_PATH'])
with zipfile.ZipFile(zip_location, 'w', zipfile.ZIP_DEFLATED) as zipf:
    for root, dirs, files in os.walk(os.environ['DWARF_DSYM_FILE_NAME']):
        zipf.write(root)

        for f in files:
            zipf.write(os.path.join(root, f))

# You may need to change the following path to match your application
# settings and Xcode version
plist_command = '/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "%s"'
p = subprocess.Popen(plist_command % os.environ['PRODUCT_SETTINGS_PATH'],
                     stdout=subprocess.PIPE, shell=True)
stdout, stderr = p.communicate()
version = stdout.strip()

curl_command = ('curl -X POST "https://api.rollbar.com/api/1/dsym" '
                '-F access_token=%s -F version=%s -F bundle_identifier="%s" '
                '-F dsym=@"%s"')
p = subprocess.Popen(curl_command % (ACCESS_TOKEN, version,
                     os.environ['PRODUCT_BUNDLE_IDENTIFIER'], zip_location),
                     shell=True)
p.communicate()
