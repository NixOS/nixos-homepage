check: all
	bash ./scripts/check-links.sh


### Asciinema demos

index.html: $(DEMOS)

demos/%.svg: demos/%.scenario
	echo "Generating $@ and $(patsubst %.svg,%.cast,$@) ..."
	asciinema-scenario --preview-file "$@" $< > $(patsubst %.svg,%.cast,$@)
	# XXX: this in until asciinema-scenario is fixed
	#      https://github.com/garbas/asciinema-scenario/issues/3
	sed -i -e "s|<nixpkgs|\&lt;nixpkgs|g" $@
