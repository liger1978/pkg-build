# pkg-build: mattermost-jira-info
A vagrant project to package
[mattermost-jira-info](https://github.com/woutervb/mattermost-jira-info) into an
RPM suitable for deployment on RHEL/CentOS 7.

## Details
This vagrant project will package
[mattermost-jira-info](https://github.com/woutervb/mattermost-jira-info) into an
RPM.  The resulting RPM package will:

  - Deploy mattermost-jira-info into `/opt/mattermost-jira-info`
  - Create a dedicated system user and group for running the service.
  - Create a systemd unit file so that mattermost-jira-info can be controlled with the standard
    service management commands, e.g.:

```bash
systemctl start mattermost-jira-info
systemctl stop mattermost-jira-info
systemctl restart mattermost-jira-info
systemctl status mattermost-jira-info
systemctl enable mattermost-jira-info
systemctl disable mattermost-jira-info
```

## Build requirements

1. [Vagrant](https://www.vagrantup.com/).
2. A hypervisor. I used [VirtualBox](https://www.virtualbox.org/).

## Configuration
You can optionally change the variables at the top of `build.sh`
 
## Target system requirements
The built RPM package is suitable for deployment on EL 7 (RHEL, CentOS, etc).
The package built package has dependencies on other system packages.  Ensure the
following Yum repos are enabled on the target system:

1. Standard distribution repos
2. [Extras repo](https://wiki.centos.org/AdditionalResources/Repositories)
3. [EPEL repo](https://fedoraproject.org/wiki/EPEL).

In addition, ensure the following packages are installed on the target system
or available in a configured Yum repo:

4. `python-tlslite`: Build using
[pkgbuild: python-tlslite vagrant project](https://github.com/liger1978/pkg-build/tree/master/python-tlslite).
5. `python-jira`: Build using
[pkgbuild: python-jira vagrant project](https://github.com/liger1978/pkg-build/tree/master/python-jira).

## Build

Initial build:

```bash
vagrant up
```
Subsequent rebuilds:

```bash
vagrant provision
```
