VERSION=0.10.11
COMPRESS=uglifyjs
SED=sed
CP=cp
RM=rm
CAT=cat
DATE=`date -uR`

ALL: js/jquery.terminal-$(VERSION).js js/jquery.terminal.js js/jquery.terminal-$(VERSION).min.js js/jquery.terminal.min.js css/jquery.terminal-$(VERSION).css css/jquery.terminal-$(VERSION).min.css css/jquery.terminal.min.css css/jquery.terminal.css README.md www/Makefile terminal.jquery.json bower.json package.json

bower.json: bower.in .$(VERSION)
	$(SED) -e "s/{{VER}}/$(VERSION)/g" bower.in > bower.json

package.json: package.in .$(VERSION)
	$(SED) -e "s/{{VER}}/$(VERSION)/g" package.in > package.json

js/jquery.terminal-$(VERSION).js: js/jquery.terminal-src.js .$(VERSION)
	$(SED) -e "s/{{VER}}/$(VERSION)/g" -e "s/{{DATE}}/$(DATE)/g" js/jquery.terminal-src.js > js/jquery.terminal-$(VERSION).js

js/jquery.terminal.js: js/jquery.terminal-$(VERSION).js
	$(CP) js/jquery.terminal-$(VERSION).js js/jquery.terminal.js

js/jquery.terminal-$(VERSION).min.js: js/jquery.terminal-$(VERSION).js
	$(COMPRESS) -o js/jquery.terminal-$(VERSION).min.js --comments --mangle -- js/jquery.terminal-$(VERSION).js

js/jquery.terminal.min.js: js/jquery.terminal-$(VERSION).min.js
	$(CP) js/jquery.terminal-$(VERSION).min.js js/jquery.terminal.min.js

css/jquery.terminal-$(VERSION).css: css/jquery.terminal-src.css .$(VERSION)
	$(SED) -e "s/{{VER}}/$(VERSION)/g" -e "s/{{DATE}}/$(DATE)/g" css/jquery.terminal-src.css > css/jquery.terminal-$(VERSION).css

css/jquery.terminal.css: css/jquery.terminal-$(VERSION).css .$(VERSION)
	$(CP) css/jquery.terminal-$(VERSION).css css/jquery.terminal.css

css/jquery.terminal.min.css: css/jquery.terminal-$(VERSION).min.css
	$(CP) css/jquery.terminal-$(VERSION).min.css css/jquery.terminal.min.css

css/jquery.terminal-$(VERSION).min.css: css/jquery.terminal-$(VERSION).css
	java -jar bin/yuicompressor-2.4.8.jar css/jquery.terminal-$(VERSION).css -o css/jquery.terminal-$(VERSION).min.css

README.md: README.in .$(VERSION)
	$(SED) -e "s/{{VER}}/$(VERSION)/g" < README.in > README.md

.$(VERSION):
	touch .$(VERSION)

terminal.jquery.json: manifest .$(VERSION)
	$(SED) -e "s/{{VER}}/$(VERSION)/g" manifest > terminal.jquery.json

www/Makefile: $(wildcard www/Makefile.in) Makefile .$(VERSION)
	test -d www && $(SED) -e "s/{{VER""SION}}/$(VERSION)/g" www/Makefile.in > www/Makefile || true

test:
	node_modules/jasmine-node/bin/jasmine-node --captureExceptions --verbose --junitreport --color --forceexit spec
jshint:
	jshint js/jquery.terminal-src.js
	jshint js/dterm.js
	jshint js/xml_formatting.js
	jshint js/unix_formatting.js
