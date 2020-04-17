# chassis-openssl
openSSL module as extension for chassis.io. See https://github.com/Chassis/Chassis and http://docs.chassis.io/en/latest/ for a lot more info.

## Usage

1. Clone this into the `extensions` folder of your Chassis installation. Use recursive: `git clone --recursive https://github.com/Chassis/chassis_openssl.git` to get the submodule pulled in as well.
1. Run `vagrant reload --provision` or just `vagrant up`
1. Profit.

## Optional Config
By default the certificate and key are regenerated on subsequent `vagrant reload --provision` & `vagrant up`. Which means you would need to re-trust the certificate each time, as the certificate serial number changes.
To configure to only create if missing, add the following to your `config.yaml`

```
# Configure ssl to keep the same cert/key
chassis_openssl:
    cert:
        replace: no
    key:
        replace: no
```

## Notes:
1. You also need to modify the `wp-config.php` in the root directory and modify the `WP_SITEURL` and `WP_HOME` constants to use https instead of http.
1. Both the certificate and key are exported to `chassis/` directory, so it can be used with local dev servers, like webpack dev server.

## Trusting the certificate

In order to avoid security errors and get that nice green padlock in your location bar, you should add the site's SSL certificate to your trust store. The certificate can be found at `chassis/{DOMAIN_HERE}.cert` .

### CLI methods

#### macOS
```
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain chassis/{DOMAIN_HERE}.cert
```

#### Windows ( running with admin privileges )
```
certutil -enterprise -f -v -AddStore "Root" "{DOMAIN_HERE}.cert"
```

### GUI methods

#### Firefox on any operating system:

- Open Firefox's Preferences.
- Go to Advanced -> Certificates -> View certificates -> Authorities.
- Import the certificate.
- Click "Trust this CA to identify web sites".

Or alternatively:

- Open Firefox
- Browse to `about:config`
- Set `security.enterprise_roots.enabled` to true

#### Chrome or Safari on Mac:

- Open the "Keychain Access" app.
- Drag the certificate into the "System" keychain.
- Right-click it and click "Get Info".
- Expand the "Trust" section if it's not already.
- Under "Secure Sockets Layer (SSL)", select "Always Trust".
- Close the window. At this point you may have to enter your Mac account password.
- Restart your browser for this to take effect.

#### IE and Edge on Windows ( [reference](https://medium.com/@ali.dev/how-to-trust-any-self-signed-ssl-certificate-in-ie11-and-edge-fa7b416cac68) )

- Browse to your page (e.g. https://vagrant.local) in Internet Explorer which should use your self-signed SSL certificate. You should be greeted by an error message saying your certificate is not trustworthy.
- Click “Continue to this website”.
- Click on “Certificate error” in the address bar, and then click “View certificates”.
- Click “Install Certificate”.
- Click “Place all certificates in the following store”, and then click “Browse”. Do not rely on the preselected option to automatically select the certificate store as this will not work!
- Inside the dialog box, click “Trusted Root Certification Authorities”, and then click “OK”.
- Finish the dialog.
- When you get a security warning, click “Yes” to trust the certificate.
- Reload your page. The certificate should be working fine now.


### Other browsers / platforms

Please submit pull-requests for instructions for browsers/platforms not listed above.

## Contributors

Props to [@javorszky](https://github.com/javorszky/) for the initial versions of the extension, and our [contributors](https://github.com/Chassis/chassis_openssl/graphs/contributors).
