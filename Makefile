#
# Makefile
#
# Instructions:
#  
#

MAJ_VER := `cat MAJOR_VERSION`
MIN_VER := `cat MINOR_VERSION`
DATE := `date +%Y%m%d`
SUFFIX := $(MAJ_VER).$(MIN_VER)-$(DATE)
ZIP_PREFIX = MarkLogic_WordAddin

ML = Addins/Word/xquery
MS = Addins/Word/Microsoft
MSS = MarkLogic_WordAddin
JS = Addins/Word/javascript
PUB_BUILD = builds/Word
MS_PUB_BUILD = $(PUB_BUILD)/addin.deploy
MS_ROOT = $(MS)/MarkLogic_WordAddin
MS_MLC_DIR = $(MS_ROOT)/MarkLogic_WordAddin/bin
MS_BUILD = $(MS_MLC_DIR)/Debug/app.publish
TEMP = temp
#
# Microsoft build
#
# Build machine path to MS compiler
#MS_IDE="C:/Program\ Files/Microsoft\ Visual\ Studio\ 9.0/Common7/IDE/devenv.exe"
#$(MS_IDE) $(MS)/$(MSS)/MarkLogic_WordAddin.sln /build Debug /Out $(MS_LOGS)/debug.log

debug: 
	@echo $(MS)/$(MSS)
	@echo $(MS_LOGS)
	@echo $(MS_IDE)
	mkdir $(TEMP)
	mkdir builds
	mkdir $(PUB_BUILD)
	mkdir $(MS_PUB_BUILD)
	cp README.txt $(PUB_BUILD)
	cp  $(MS_ROOT)/$(MSS)/IonControl1.cs  $(TEMP)/IonControl1.cs.bak
	./setVersion patch $(MS_ROOT)/$(MSS)/IonControl1.cs  $(MS_ROOT)/$(MSS)/IonControl2.cs
	rm $(MS_ROOT)/$(MSS)/IonControl1.cs
	mv $(MS_ROOT)/$(MSS)/IonControl2.cs $(MS_ROOT)/$(MSS)/IonControl1.cs
	build-addin.bat
	mv $(TEMP)/IonControl1.cs.bak  $(MS_ROOT)/$(MSS)/IonControl1.cs
	cp -r   $(MS_BUILD)/* $(MS_PUB_BUILD)/.
	./setVersion patch $(JS)/MarkLogicWordAddin.js $(PUB_BUILD)/MarkLogicWordAddin.js
	./setVersion patch $(ML)/word-addin.xqy $(PUB_BUILD)/word-addin.xqy
	cp $(ML)/custom-xml.xqy $(PUB_BUILD)/custom-xml.xqy
	@echo Create zip file $(ZIP_PREFIX)_$(SUFFIX).zip
	(cd builds; zip -r ../$(ZIP_PREFIX).zip Word/*)
	mv $(ZIP_PREFIX).zip $(ZIP_PREFIX)-$(SUFFIX).zip

clean:
	rm -rf builds
	rm -rf $(MS_PUB_BUILD)
	rm  $(PUB_BUILD)/*.xqy
	rm  $(PUB_BUILD)/*.js
	rm -rf $(MS_BUILD)/*
	rm ./*.zip
	rm -rf $(TEMP)

