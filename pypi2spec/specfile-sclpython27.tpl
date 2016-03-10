%{?scl:%scl_package package_name}
%{!?scl:%global pkg_name %{name}}

%{!?python_sitelib: %global python_sitelib %(%{__python} -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())")}
%{!?python_sitearch: %global python_sitearch %(%{__python} -c "from distutils.sysconfig import get_python_lib; print(get_python_lib(1))")}

%global modname {{ modname }}
%global sum     {{ summary }}

Name:               %{?scl_prefix}python-{{ barename }}
Version:            {{ version }}
Release:            1%{?dist}
Summary:            %{sum}

License:            {{ license }}
URL:                {{ URL }}
Source0:            {{ _source0 }}

{%- if (arch == False) -%}
BuildArch:          noarch
{%- endif %}

BuildRequires:      python2-devel
BuildRequires:      python2-setuptools

%{?scl:Requires: %scl_runtime}

Requires:           python-...

%description
{{ description }}

%prep
%autosetup -n %{modname}-%{version}

%build
CFLAGS="$RPM_OPT_FLAGS" %{__python} setup.py build

%install
rm -rf %{buildroot}
%{__python} setup.py install -O1 --skip-build --root %{buildroot}

# Disable tests for now
# %check
# %{__python} setup.py test

%files -n %{?scl_prefix}python-%{modname}
%doc README.rst
%license LICENSE
{% if (arch == False) -%}
%{python_sitelib}/%{modname}/
%{python_sitelib}/%{modname}-%{version}*
{%- else -%}
%{python_sitearch}/%{modname}/
%{python_sitearch}/%{modname}-%{version}*
{%- endif %}

%changelog
* {{ date }} {{ packager }} <{{ email }}> {{ version }}-1
- initial package for CentOS Sclo SIG
