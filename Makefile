# Transform PDF of a scanned book into beautiful searchable PDF :-)
# depends on convert (ImageMagick), pdftk, tesseract and hocr2pdf (ExactImage)
#
# Reference:
#   http://blog.konradvoelkel.de/2013/03/scan-to-pdfa/
#   http://blog.konradvoelkel.de/2010/01/linux-ocr-and-pdf-problem-solved/
#
#
# Usage: make

# LANG is a language as in `tesseract --list-langs`
LANG=eng

all: pdf2bmp recognition merge

pdf2bmp:
	@mkdir -p processing; \
	fullpath=`realpath $(PDF)`; \
	echo "Pdf2bmp: $${fullpath}"; \
	cd processing && pdfimages -j $${fullpath} image;
	@for f in processing/image*; do \
		base=`basename $$f`; \
		convert $$f processing/$${base}.bmp; \
		rm $$f; \
	done

recognition:
	@cd processing && for f in image*.bmp; do \
		base=`basename $$f .bmp`; \
		echo "Recognition: $${base}"; \
		convert -normalize -monochrome -depth 8 $${base}.bmp $${base}.png; \
		tesseract -l $(LANG) $${base}.png $${base} hocr; \
		convert $${base}.bmp $${base}.jpg; \
		hocr2pdf -i $${base}.jpg -s -o $${base}.done.pdf < $${base}.html; \
	done
merge:
	@cd processing && \
	echo "InfoKey: Author" > info && \
	echo "InfoValue: $(AUTHOR)" >> info && \
	echo "InfoKey: Title" >> info && \
	echo "InfoValue: $(TITLE)" >> info && \
	echo "InfoKey: Creator" >> info && \
	echo "InfoValue: PDF OCR scan script" >> info;
	@pdftk processing/*.done.pdf cat output processing/ocr.pdf
	@pdftk processing/ocr.pdf update_info processing/info output ocr.pdf

clean:
	@echo "Cleaning..."
	@rm -rf processing
