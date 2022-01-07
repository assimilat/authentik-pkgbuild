# Maintainer: Andrew Tyler <assimilat@gmail.com>
pkgbase=authentik-git
pkgname=('authentik-frontend' 'authentik-backend' 'authentik-proxy' 'authentik-ldap')
pkgver=2022.01.07_r7869.dc5667b0b
pkgrel=1
pkgdesc="Authentik auth server"
url="https://github.com/authentikdata/authentik"
arch=('any')
license=('AGPL-3.0')
depends=('postgresql' 'python' 'python-poetry' 'pwgen' 'npm' 'go' 'prettier')
makedepends=('postgresql-libs' 'git')
source=("$pkgbase::git+https://github.com/goauthentik/authentik.git"
        "authentik-frontend.service"
        "authentik-backend.service"
				"authentik-proxy.service"
        "authentik-ldap.service"
        "authentik-ldap.conf"
        "authentik-proxy.conf"
        "authentik-backend"
        "configure-authentik-proxy.sh"
        "configure-authentik-ldap.sh")
sha1sums=('SKIP'
          'dc9a31eb8a8b9bd20f0b2260299f76a6f829cd2e'
          '9415291896c52b5182498b86415c119a8eb57b0a'
          '89b9e2636a5fad4ab6f5ac5dbbedef785a0d2b80'
          'b428744642be15ceddb33c2edeb8989e2fa927c2'
          'b5845eaad095f523cad73f17ee1fd45053498ade'
          '3f5715a1550fe24702ff23e67c8c17e7e55d790f'
          '7d2b925106ab0d1e71eeb92c1687f95feab59e20'
          '14e7172d2b11d26b50e1bd98d6fccdeaa89cd0bd'
          'f3470226db0a69f0cd98239c9ac0d6289e2342b1')

pkgver() {
  cd ${srcdir}/${pkgbase}
  echo "`date +%Y.%m.%d`_`printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"`"
}

build() {
	cd "${srcdir}/${pkgbase}"
  cd web
  npm install
  npm run extract
  npm run build
  cd "${srcdir}/${pkgbase}"
  make web
  mkdir ../go;
  GOPATH="${srcdir}/go";
  go build cmd/proxy/server.go;
  go build -o authentik-proxy cmd/proxy/server.go
  go build -o authentik-ldap cmd/ldap/server.go
  go build -o authentik-server cmd/server/main.go
	export POETRY_VIRTUALENVS_PATH="${srcdir}/${pkgbase}/venv"
	poetry install
  sed -i "s%[.][\/]local[.]env[.]yml%/etc/webapps/authentik/config.yml%g" "${srcdir}/${pkgbase}/cmd/server/main.go"
}

package_authentik-proxy() {
  pkgdesc="Autentik proxy outpost"  
  install=authentik-proxy.install
  cd "${srcdir}/${pkgbase}"
  install -D -m644 "${srcdir}/authentik-proxy.service" "${pkgdir}/usr/lib/systemd/system/authentik-proxy.service"
  install -D -m755 "${srcdir}/${pkgbase}/server" "${pkgdir}/usr/bin/authentik-proxy"
  install -D -m755 "${srcdir}/configure-authentik-proxy.sh" "${pkgdir}/usr/bin/configure-authentik-proxy"
  install -D -m644 "${srcdir}/authentik-proxy.conf" "${pkgdir}/conf.d/authentik-proxy"
}

package_authentik-ldap() {
  pkgdesc="Authentik LDAP outpost"
  install=authentik-ldap.install
  cd "${srcdir}/${pkgbase}"
  install -D -m644 "${srcdir}/authentik-ldap.service" "${pkgdir}/usr/lib/systemd/system/authentik-ldap.service"
  install -D -m755 "${srcdir}/${pkgbase}/authentik-ldap" "${pkgdir}/usr/bin/authentik-ldap"
  install -D -m755 "${srcdir}/configure-authentik-ldap.sh" "${pkgdir}/usr/bin/configure-authentik-ldap"
  install -D -m644 "${srcdir}/authentik-ldap.conf" "${pkgdir}/conf.d/authentik-ldap"
}

package_authentik-frontend() {
  pkgdesc="Authentik frontend server"
  install=authentik-frontend.install
  cd "${srcdir}/${pkgbase}"
  mkdir -p "${pkgdir}/usr/share/webapps/authentik"
  cp -R ./web/* "${pkgdir}/usr/share/webapps/authentik"
  install -D -m644 "${srcdir}/authentik-frontend.service" "${pkgdir}/usr/lib/systemd/system/authentik-frontend.service"
  install -D -m644 "${srcdir}/${pkgbase}"/authentik/lib/default.yml $"${pkgdir}/etc/webapps/authentik/config.yml"
}

package_authentik-backend() {
  pkgdesc="Authentik backend server"
  install=authentik-backend.install
	cd "${srcdir}/${pkgbase}"
	mkdir -p "${pkgdir}/var/lib/authentik"
	cd "${srcdir}/${pkgbase}"
  cp -R * "${pkgdir}/var/lib/authentik/"
  install -D -m644 "${srcdir}/authentik-backend.service" "${pkgdir}/usr/lib/systemd/system/authentik-backend.service"
  install -D -m755 "${srcdir}/authentik-backend" "${pkgdir}/usr/bin/authentik-backend"
  install -D -m755 "${srcdir}/${pkgbase}/authentik-server" "${pkgdir}/usr/bin/authentik-server"
  rm -rf "${pkgdir}"/var/lib/authentik/{authentik-proxy,authentik-ldap,cmd,web,website,.git,.vscode,Dockerfile,docker-compose.yml}
}
