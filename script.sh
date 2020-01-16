#!/bin/bash
# on écrit une fonction qui installe Tomcat
tomcat_install(){
# on vérifie la présence du fichier Tomcat et on le décompresse
	if [[ -e apache-tomcat-7.0.75.tar.gz ]]
	then
		tar -zxf apache-tomcat-7.0.75.tar.gz --directory ~/
	else
		echo "fichier Tomcat non présent"
	fi

# on vérifie que le repertoire a bien étét créé
	if [[ -d ~/apache-tomcat-7.0.75 ]]
	then
		echo "archive Tomcat bien décompressée"
	fi

# on test la présence de java, si il n'est pas présent on l'installe
	dpkg -s default-jdk | grep Status
	if [ $? -gt  0 ]
	then
		apt-get install default-jdk
		echo "jdk a bien été installé"
	else
		echo "java est déjà installé"
	fi

# on définit les variables d'environements dan le bashrc et on le source
	echo "JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64" >> ~/.bashrc 
	echo "CATALINA_HOME=/opt/tomcat/apache-tomcat-7.0.75" >> ~/.bashrc
	source ~/.bashrc
}

# on écrit une fonction qui installe jenkins
jenkins_install(){
# on vérifie la présence du fichier jenkins et on le déplace dans le dossier Tomcat webapps
	if [[ -e jenkins46.war ]]
	then
		if [[ -e /home/testeur/apache-tomcat-7.0.75/webapps/jenkins46.war ]]
		then
			echo "Jenkins est déjà présent"
		else
			cp jenkins46.war ~/apache-tomcat-7.0.75/webapps/
			echo "Jenkins a été copié"
		fi
	else
		echo "fichier jenkins non présent"
	fi
}

# on vérifie si le dossier Tomcat existe, sinon on l'installe
if [[ -d ~/apache-tomcat-7.0.75 ]]
then
	echo "Tomcat est déjà présent"
else
	echo "On installe Tomcat"
	tomcat_install
fi

# on vérifie si Tomcat est lancé pour pouvoir déployer jenkins:
# on utilise la liste des processus qu'on filtre avec grep en ne gardant que ceux qui ont
# apache.catalina dans leur nom, puis on exclu les processus grep et on sélectionne la deuxième
# colonne qui correspond au PID.
test=$(ps aux | grep apache.catalina | grep -v grep | awk '{print $2}')
echo "valeur test: " $test
# si le PID est non nul, Tomcat est lancé
if [ -z "$test" ]
then
	echo "Ok Tomcat n'est pas lancé, on déploie jenkins"
# on installe jenkins
	jenkins_install
# on lance Tomcat
	/home/testeur/apache-tomcat-7.0.75/bin/startup.sh
else
	echo "Tomcat est lancé"
# on éteint Tomcat
	/home/testeur/apache-tomcat-7.0.75/bin/shutdown.sh
	echo "Tomcat est éteint, on déploie jenkins"
# on installe jenkins
	jenkins_install
# on lance Tomcat
	/home/testeur/apache-tomcat-7.0.75/bin/startup.sh
fi
