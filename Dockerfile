ARG IMAGE=intersystemsdc/iris-community
FROM $IMAGE

USER root

WORKDIR /opt/irisapp
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp

USER irisowner

COPY  Installer.cls .
COPY  src src
COPY irissession.sh /
SHELL ["/irissession.sh"]

RUN \
  do $SYSTEM.OBJ.Load("Installer.cls", "ck") \
  set sc = ##class(App.Installer).setup() \
  zn "%SYS" \
  write "Create web application ..." \
  set webName = "/crud" \
  set webProperties("DispatchClass") = "Sample.PersonREST" \
  set webProperties("NameSpace") = "IRISAPP" \
  set webProperties("Enabled") = 1 \
  set webProperties("AutheEnabled") = 32 \
  set sc = ##class(Security.Applications).Create(webName, .webProperties) \
  write sc \
  write "Web application "_webName_" has been created!" 
  #zn "IRISAPP" \
  #zpm "install swagger-ui" \
  #zpm "install webterminal"

# bringing the standard shell back
SHELL ["/bin/bash", "-c"]
CMD [ "-l", "/usr/irissys/mgr/messages.log" ]