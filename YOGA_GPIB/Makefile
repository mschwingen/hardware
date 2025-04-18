all:	doc step bom

PCB=yoga_v2.kicad_pcb
SCH=yoga_v2.kicad_sch
OUT_BASENAME=yoga_v2
FINALDOC=Doc/$(OUT_BASENAME).pdf
LAYERS=F.Cu,B.Cu,F.Paste,B.Paste,F.Silkscreen,B.Silkscreen,F.Mask,B.Mask,Edge.Cuts
DOCS=\
	Doc/Schematic.pdf \
	Doc/PCB_Drawing.pdf \
	Doc/PCB_FrontSilk.pdf \
	Doc/PCB_BackSilk.pdf \
	Doc/PCB_FrontFab.pdf \
	Doc/PCB_BackFab.pdf \
	Doc/PCB_Front.pdf \
	Doc/PCB_Back.pdf

cam:	$(PCB)
	-mkdir CAM
	-rm CAM/*
	kicad-cli pcb export drill -o CAM/ --format excellon \
	--drill-origin plot --excellon-zeros-format decimal -u mm \
	--excellon-oval-format route \
	--generate-map --map-format pdf \
	$(PCB)

	kicad-cli pcb export gerbers -o CAM/ -l $(LAYERS) \
	--subtract-soldermask --use-drill-file-origin \
	$(PCB)

	kicad-cli pcb export pos -o CAM/$(OUT_BASENAME).pos \
	--side both --format ascii --units mm \
	--use-drill-file-origin \
	$(PCB)

	zip CAM/$(OUT_BASENAME).zip CAM/*

step:	$(PCB)
	kicad-cli pcb export step -o Doc/$(OUT_BASENAME).step \
	--drill-origin --subst-models -f \
	$(PCB)

Doc:
	-mkdir Doc

doc:	$(FINALDOC) Doc/uart-conn.svg Doc/expansion-conn.svg

$(FINALDOC):	$(DOCS)
	pdftk $(DOCS) output $@

Doc/PCB_Front.pdf: $(PCB) Doc
	kicad-cli pcb export pdf -o Doc/tmp.pdf -l Edge.Cuts,F.Cu --black-and-white $<
	podofocrop Doc/tmp.pdf $@
	rm Doc/tmp.pdf

Doc/PCB_Back.pdf: $(PCB) Doc
	kicad-cli pcb export pdf -o Doc/tmp.pdf  -l Edge.Cuts,B.Cu --black-and-white --mirror $<
	podofocrop Doc/tmp.pdf $@
	rm Doc/tmp.pdf

Doc/PCB_FrontSilk.pdf: $(PCB) Doc
	#kicad-cli pcb export pdf -o Doc/tmp.pdf --theme PdfPCB1 -l Edge.Cuts,F.Cu,F.Silkscreen $<
	kicad-cli pcb export pdf -o Doc/tmp.pdf --theme PdfPCB1 -l Edge.Cuts,F.Silkscreen $<
	podofocrop Doc/tmp.pdf $@
	rm Doc/tmp.pdf

Doc/PCB_BackSilk.pdf: $(PCB) Doc
	kicad-cli pcb export pdf -o Doc/tmp.pdf  --theme PdfPCB1 -l Edge.Cuts,B.Silkscreen --mirror $<
	podofocrop Doc/tmp.pdf $@
	rm Doc/tmp.pdf

Doc/PCB_FrontFab.pdf: $(PCB) Doc
	#kicad-cli pcb export pdf -o Doc/tmp.pdf --theme PdfPCB1 -l Edge.Cuts,F.Fab,F.Cu $<
	kicad-cli pcb export pdf -o Doc/tmp.pdf --theme PdfPCB1 -l Edge.Cuts,F.Fab $<
	podofocrop Doc/tmp.pdf $@
	rm Doc/tmp.pdf

Doc/PCB_BackFab.pdf: $(PCB) Doc
	kicad-cli pcb export pdf -o Doc/tmp.pdf  --theme PdfPCB1 -l Edge.Cuts,B.Fab --mirror $<
	podofocrop Doc/tmp.pdf $@
	rm Doc/tmp.pdf

Doc/PCB_Drawing.pdf: $(PCB) Doc
	kicad-cli pcb export pdf -o Doc/tmp.pdf --theme PdfPCB1 -l Edge.Cuts,F.Cu,User.Drawings $<
	podofocrop Doc/tmp.pdf $@
	rm Doc/tmp.pdf

Doc/Schematic.pdf: $(SCH) Doc
	kicad-cli sch export pdf -o Doc/tmp.pdf --theme PdfSchematic -n $<
	podofocrop Doc/tmp.pdf $@
	rm Doc/tmp.pdf

Doc/uart-conn.svg: uart-conn.yml
	wireviz -o Doc/uart-conn $<

Doc/expansion-conn.svg: expansion-conn.yml
	wireviz -o Doc/expansion-conn $<

.phony: bom

bom: BOM/$(OUT_BASENAME)_bom.xml BOM/$(OUT_BASENAME)_bom.csv BOM/$(OUT_BASENAME)_bom.html

BOM/$(OUT_BASENAME)_bom.xml: $(SCH)
	-mkdir BOM
	kicad-cli sch export python-bom $(SCH) -o $@

BOM/$(OUT_BASENAME)_bom.csv: BOM/$(OUT_BASENAME)_bom.xml
	python3 ~/kicad/kibom/KiBOM_CLI.py --cfg bom.ini $< $@

BOM/$(OUT_BASENAME)_bom.html: BOM/$(OUT_BASENAME)_bom.xml
	python3 ~/kicad/kibom/KiBOM_CLI.py --cfg bom.ini $< $@
