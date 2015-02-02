# Census Bureau Geographic Hierarchy
# http://www.census.gov/geo/www/geodiagram.html

# states:
# al ak az ar ca co ct de dc fl
# ga hi id il in ia ks ky la me
# md ma mi mn ms mo mt ne nv nh
# nj nm ny nc nd oh ok or pa ri
# sc sd tn tx ut vt va wa wv wi
# wy

# territories with counties:
# pr vi

# territories without counties:
# as fm gu mh mp pw um

all:

.SECONDARY:

# Zip Code Tabulation Areas
gz/tl_2012_us_zcta510.zip:
	mkdir -p $(dir $@)
	curl 'http://www2.census.gov/geo/tiger/TIGER2012/ZCTA5/$(notdir $@)' -o $@.download
	mv $@.download $@

# Zip Code Tabulation by State
gz/tl_2010_%_zcta510.zip:
	mkdir -p $(dir $@)
	curl 'http://www2.census.gov/geo/tiger/TIGER2010/ZCTA5/2010/$(notdir $@)' -o $@.download
	mv $@.download $@

shp/us/zipcodes-unmerged.shp: gz/tl_2012_us_zcta510.zip

shp/al/zipcodes.shp: gz/tl_2010_01_zcta510.zip
shp/ak/zipcodes.shp: gz/tl_2010_02_zcta510.zip
shp/az/zipcodes.shp: gz/tl_2010_04_zcta510.zip
shp/ar/zipcodes.shp: gz/tl_2010_05_zcta510.zip
shp/ca/zipcodes.shp: gz/tl_2010_06_zcta510.zip
shp/co/zipcodes.shp: gz/tl_2010_08_zcta510.zip
shp/ct/zipcodes.shp: gz/tl_2010_09_zcta510.zip
shp/de/zipcodes.shp: gz/tl_2010_10_zcta510.zip
shp/dc/zipcodes.shp: gz/tl_2010_11_zcta510.zip
shp/fl/zipcodes.shp: gz/tl_2010_12_zcta510.zip
shp/ga/zipcodes.shp: gz/tl_2010_13_zcta510.zip
shp/hi/zipcodes.shp: gz/tl_2010_15_zcta510.zip
shp/id/zipcodes.shp: gz/tl_2010_16_zcta510.zip
shp/il/zipcodes.shp: gz/tl_2010_17_zcta510.zip
shp/in/zipcodes.shp: gz/tl_2010_18_zcta510.zip
shp/ia/zipcodes.shp: gz/tl_2010_19_zcta510.zip
shp/ks/zipcodes.shp: gz/tl_2010_20_zcta510.zip
shp/ky/zipcodes.shp: gz/tl_2010_21_zcta510.zip
shp/la/zipcodes.shp: gz/tl_2010_22_zcta510.zip
shp/me/zipcodes.shp: gz/tl_2010_23_zcta510.zip
shp/md/zipcodes.shp: gz/tl_2010_24_zcta510.zip
shp/ma/zipcodes.shp: gz/tl_2010_25_zcta510.zip
shp/mi/zipcodes.shp: gz/tl_2010_26_zcta510.zip
shp/mn/zipcodes.shp: gz/tl_2010_27_zcta510.zip
shp/ms/zipcodes.shp: gz/tl_2010_28_zcta510.zip
shp/mo/zipcodes.shp: gz/tl_2010_29_zcta510.zip
shp/mt/zipcodes.shp: gz/tl_2010_30_zcta510.zip
shp/ne/zipcodes.shp: gz/tl_2010_31_zcta510.zip
shp/nv/zipcodes.shp: gz/tl_2010_32_zcta510.zip
shp/nh/zipcodes.shp: gz/tl_2010_33_zcta510.zip
shp/nj/zipcodes.shp: gz/tl_2010_34_zcta510.zip
shp/nm/zipcodes.shp: gz/tl_2010_35_zcta510.zip
shp/ny/zipcodes.shp: gz/tl_2010_36_zcta510.zip
shp/nc/zipcodes.shp: gz/tl_2010_37_zcta510.zip
shp/nd/zipcodes.shp: gz/tl_2010_38_zcta510.zip
shp/oh/zipcodes.shp: gz/tl_2010_39_zcta510.zip
shp/ok/zipcodes.shp: gz/tl_2010_40_zcta510.zip
shp/or/zipcodes.shp: gz/tl_2010_41_zcta510.zip
shp/pa/zipcodes.shp: gz/tl_2010_42_zcta510.zip
shp/ri/zipcodes.shp: gz/tl_2010_44_zcta510.zip
shp/sc/zipcodes.shp: gz/tl_2010_45_zcta510.zip
shp/sd/zipcodes.shp: gz/tl_2010_46_zcta510.zip
shp/tn/zipcodes.shp: gz/tl_2010_47_zcta510.zip
shp/tx/zipcodes.shp: gz/tl_2010_48_zcta510.zip
shp/ut/zipcodes.shp: gz/tl_2010_49_zcta510.zip
shp/vt/zipcodes.shp: gz/tl_2010_50_zcta510.zip
shp/va/zipcodes.shp: gz/tl_2010_51_zcta510.zip
shp/wa/zipcodes.shp: gz/tl_2010_53_zcta510.zip
shp/wv/zipcodes.shp: gz/tl_2010_54_zcta510.zip
shp/wi/zipcodes.shp: gz/tl_2010_55_zcta510.zip
shp/wy/zipcodes.shp: gz/tl_2010_56_zcta510.zip
shp/as/zipcodes.shp: gz/tl_2010_60_zcta510.zip

shp/us/%.shp:
	rm -rf $(basename $@)
	mkdir -p $(basename $@)
	tar -xzm -C $(basename $@) -f $<
	for file in $(basename $@)/*; do chmod 644 $$file; mv $$file $(basename $@).$${file##*.}; done
	rmdir $(basename $@)

# merge geometries
shp/us/%.json: shp/us/%-unmerged.shp bin/geomerge
	@rm -f -- $@ $(basename $@)-unmerged.json
	ogr2ogr -f 'GeoJSON' $(basename $@)-unmerged.json $<
	bin/geomerge < $(basename $@)-unmerged.json > $@

shp/us/zipcodes-unmerged.shp shp/us/cbsa.shp shp/%/tracts.shp shp/%/blockgroups.shp shp/%/blocks.shp shp/%/zipcodes.shp:
	rm -rf $(basename $@)
	mkdir -p $(basename $@)
	unzip -d $(basename $@) $<
	for file in $(basename $@)/*; do chmod 644 $$file; mv $$file $(basename $@).$${file##*.}; done
	rmdir $(basename $@)
	touch $@

topo/%-zipcodes-10m-ungrouped.json: shp/%/zipcodes.shp
	mkdir -p $(dir $@)
	node_modules/.bin/topojson \
		-o $@ \
		--no-pre-quantization \
		--post-quantization=1e6 \
		--simplify=7e-7 \
		--id-property=+GEOID10 \
		--properties zip=ZCTA5CE10 \
		-- $<

topo/%-zipcodes-10m.json: topo/%-zipcodes-10m-ungrouped.json
	node_modules/.bin/topojson-group \
		-o $@ \
		-- topo/$*-zipcodes-10m-ungrouped.json

# merge in zip data
zipcode/%.json: topo/%-zipcodes-10m.json
	mkdir -p $(dir $@)
	bin/zipdata \
		-c US\ ZIP\ codes.csv \
		-t topo/$*-zipcodes-10m.json \
		> $@

# group by pocode
poname/%.json: zipcode/%.json
	mkdir -p $(dir $@)
	bin/merge-ponames \
		-o $@ \
		-i $<

state-zipcodes: \
	poname/al.json \
	poname/ak.json \
	poname/az.json \
	poname/ar.json \
	poname/ca.json \
	poname/co.json \
	poname/ct.json \
	poname/de.json \
	poname/dc.json \
	poname/fl.json \
	poname/ga.json \
	poname/hi.json \
	poname/id.json \
	poname/il.json \
	poname/in.json \
	poname/ia.json \
	poname/ks.json \
	poname/ky.json \
	poname/la.json \
	poname/me.json \
	poname/md.json \
	poname/ma.json \
	poname/mi.json \
	poname/mn.json \
	poname/ms.json \
	poname/mo.json \
	poname/mt.json \
	poname/ne.json \
	poname/nv.json \
	poname/nh.json \
	poname/nj.json \
	poname/nm.json \
	poname/ny.json \
	poname/nc.json \
	poname/nd.json \
	poname/oh.json \
	poname/ok.json \
	poname/or.json \
	poname/pa.json \
	poname/ri.json \
	poname/sc.json \
	poname/sd.json \
	poname/tn.json \
	poname/tx.json \
	poname/ut.json \
	poname/vt.json \
	poname/va.json \
	poname/wa.json \
	poname/wv.json \
	poname/wi.json \
	poname/wy.json

