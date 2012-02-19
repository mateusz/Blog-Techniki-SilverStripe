local:
	rm -fr _site
	jekyll --no-auto

remote:
	rm -fr _site_remote
	jekyll --no-auto --url http://mateusz.uzdowski.pl --base-url http://mateusz.uzdowski.pl/ ./_site_remote
	chmod -R a+r _site_remote
