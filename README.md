# ForemanOmaha

This plug-in enables CoreOS updates using [The Foreman](https://theforeman.org/) without using the public update infrastructure.
To follow along with common Foreman architecture, you need this Foreman plug-in installed and a [Smart-Proxy plugin](https://github.com/theforeman/smart_proxy_omaha). The smart-proxy plug-in does all the heavy lifting. The Foreman plug-in shows facts and reports for your hosts.
Foreman core already supports deploying CoreOS hosts and is great for on-premise setups. This plug-in enables you to better manage your servers.

## Compatibility

| Foreman Version | Plugin Version |
| --------------- | -------------- |
| >= 1.12         | any            |

## Installation

See [Plugins install instructions](https://theforeman.org/plugins/)
for how to install Foreman plugins.
You need to install the package `tfm-rubygem-foreman_omaha` or use foreman-installer.

To prepare the Foreman database, issue the following command:

```
foreman-rake db:migrate SCOPE=foreman_omaha
```

## Uninstalling

You need to revert all database changes made when installing this plug-in:

```
foreman-rake db:migrate SCOPE=foreman_omaha VERSION=0
```

You can then safely remove the operating system package and restart Foreman.

## Copyright

Copyright (c) 2016 The Foreman developers

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

