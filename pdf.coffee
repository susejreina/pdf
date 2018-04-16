util = require 'util'
PDFDocument = require 'pdfkit'
fs = require 'fs'
QRCode = require('qrcode')

module.exports =
	createPDF: (req, res) ->
		QRCode.toFile('./tmp/qrCode.png', 'https://verificacfdi.facturaelectronica.sat.gob.mx/default.aspx&id=F7C0E3BC-B09D-482F-881E-3F6B063DED31&re=AAA010101AAA&rr=XXX010101XXA&tt=125.6&fe=A1345678', {
			color: {
				dark: '#000',
				light: '#FFF'
			}
		}, (err) ->
			if err
				console.log err
			# Create a document
			doc = new PDFDocument {
				margins : {
						top: 50, 
						bottom: 50,
						left: 40,
						right: 40
				},
				layout: 'portrait',
				info: {
						Title: 'PDF', 
						Author: 'Nombre del Consultorio',
						Subject: 'Factura',
						Keywords: 'pdf;cfdi'
				}
			}

			# Pipe its output somewhere, like to a file or HTTP response
			# See below for browser usage
			#filePath = __dirname + "/files/output1.pdf"
			#doc.pipe fs.createWriteStream(filePath)
			res.contentType "application/pdf"
			doc.pipe res

			fontTitle = 10
			fontText = 10

			colorBack = '#bfbfbf'
			colorBorder = 'black'

			initialX = 40
			initialY = 140 
			firstInitialY = initialY #Si no tiene imagen es 50
			interline = 14
			#Escribimos la primera columna
			doc.fontSize(fontTitle)
				.font('Helvetica-Bold')
				.text('RFC Emisor:', initialX, initialY)
				.text('Lugar Exp.:', initialX, initialY+interline)
				.text('Fecha:', initialX, initialY+(interline*2))
				.text('Comprobante:', initialX, initialY+(interline*3))
				.text('Serie:', initialX, initialY+(interline*4))
				.text('Folio:', initialX, initialY+(interline*5))

			initialX = 120
			doc.fontSize(fontText)
				.font('Helvetica')
				.text('AIFF370227N22', initialX, initialY)
				.text('66633', initialX, initialY+interline)
				.text('2018-03-05 12:15:55', initialX, initialY+(interline*2))
				.text('Ingreso', initialX, initialY+(interline*3))
				.text('X8BIT', initialX, initialY+(interline*4))
				.text('2', initialX, initialY+(interline*5))

			initialX = 225
			doc.fontSize(fontTitle)
				.font('Helvetica-Bold')
				.text('Nombre Emisor:', initialX, initialY)
				.text('UUID:', initialX, initialY+interline)
				.text('Régimen Fiscal:', initialX, initialY+(interline*2))
				.text('RFC Receptor:', initialX, initialY+(interline*3))
				.text('Nombre Receptor:', initialX, initialY+(interline*4))
				.text('Uso CFDI:', initialX, initialY+(interline*5))

			initialX = 320
			doc.fontSize(fontText)
				.font('Helvetica')
				.text('X8BIT ', initialX, initialY)
				.text('34DCA481-4F16-4500-A82E-85ED4FD51D28', initialX, initialY+interline)
				.text('Ley de Personas Naturales', initialX, initialY+(interline*2))
				.text('XBI15021618A', initialX, initialY+(interline*3))
				.text('FERNANDO ANCIRA FLORES', initialX, initialY+(interline*4))
				.text('Gastos en general', initialX, initialY+(interline*5))

			initialX = 40
			initialY = initialY + 85
			doc.fontSize(12)
				.font 'Helvetica-Bold'
				.text 'CONCEPTOS', initialX, initialY,
					align: 'left'

			initialX = 40
			initialY = initialY + 15

			doc.fontSize fontTitle
				.font 'Helvetica-Bold'

			tableTitle = [{
										nombre: 'ClaveProdServ',
										ancho: '76'
										},
										{
										nombre: 'No Identificación',
										ancho: '92'
										},
										{
										nombre: 'ClaveUnidad',
										ancho: '75'
										},
										{
										nombre: 'Cantidad',
										ancho: '57'
										},
										{
										nombre: 'ValorUnitario',
										ancho: '80'
										},
										{
										nombre: 'Importe',
										ancho: '96'
										},
										{
										nombre: 'Descuento',
										ancho: '60'
										}]

			col = 0
			while col < tableTitle.length
				doc.rect initialX, initialY, tableTitle[col].ancho, 20
					.fillAndStroke colorBack,'black'
				doc.fillColor 'black'
					.text tableTitle[col].nombre, initialX, initialY+5,
						width: tableTitle[col].ancho
						align: 'center'
				initialX = initialX + parseInt(tableTitle[col].ancho)
				col++

			initialY = initialY + 20
			conceptos = 0
			qtyConceptos = 4
			while conceptos < qtyConceptos
				initialX = 40

				doc.fontSize fontTitle
					.font 'Helvetica'
				
				doc.rect initialX, initialY, 76, 20
					.fillAndStroke 'white', 'black'
				doc.fillColor 'black'
					.text '80131502', initialX, initialY+5,
						width: 76
						align: 'center'
				
				initialX = initialX + 76
				doc.rect initialX, initialY, 92, 20
					.fillAndStroke 'white', 'black'
				doc.fillColor 'black'
					.text 'SERV001', initialX, initialY+5,
						width: 92
						align: 'center'
					
				initialX = initialX + 92
				doc.rect initialX, initialY, 75, 20
					.fillAndStroke 'white','black'
				doc.fillColor 'black'
					.text 'E48', initialX, initialY+5,
						width: 75
						align: 'center'
				
				initialX = initialX + 75
				doc.rect initialX, initialY, 57, 20
					.fillAndStroke 'white', 'black'
				doc.fillColor 'black'
					.text '2', initialX, initialY+5,
						width: 57
						align: 'center'
				
				initialX = initialX + 57
				doc.rect initialX,initialY, 80, 20 
					.fillAndStroke 'white','black'
				doc.fillColor 'black'
					.text '400.00', initialX, initialY+5,
						width: 80
						align: 'center'
				
				initialX = initialX + 80
				doc.rect initialX,initialY,96,20
					.fillAndStroke 'white','black'
				doc.fillColor 'black'
					.text '800.00', initialX, initialY+5,
						width: 96
						align: 'center'

				initialX = initialX + 96
				doc.rect initialX,initialY,60,20
					.fillAndStroke 'white','black'
				doc.fillColor 'black'
					.text '0.00', initialX, initialY+5,
						width: 60
						align: 'center'

				initialX = 40
				initialY = initialY + 20

				doc.fontSize(12)
					.font('Helvetica-Bold');

				doc.rect initialX, initialY, 76, 40
					.fillAndStroke(colorBack,'black')
				doc.fontSize fontTitle
					.fillColor 'black'
					.text 'Descripción', initialX, initialY + 15,
						width: 76
						align: 'center'

				initialX = initialX + 76
				doc.rect initialX, initialY, 224, 40
					.fillAndStroke('white','black')
				doc.font 'Helvetica'
					.fillColor 'black'
					.text 'Consulta médica dufi usouf os uouou o uo Consulta médica dufi usouf os uouou o uo médica dufi usouf os uouou o uo', initialX + 3 , initialY + 5 ,
						width: 218
						align: 'justify'

				initialX = initialX + 224
				doc.fontSize 9
					.font 'Helvetica-Bold'
					.text 'Impuesto', initialX + 3 , initialY + 3 ,
						width: 45
						align: 'left'

				initialX = initialX + 45
				doc.text 'Tipo', initialX + 3 , initialY + 3 ,
						width: 30
						align: 'center'

				initialX = initialX + 30
				doc.text 'TipoFactor', initialX + 3 , initialY + 3 ,
						width: 50
						align: 'center'

				initialX = initialX + 50
				doc.text 'TasaOCuota', initialX + 3 , initialY + 3 ,
						width: 64
						align: 'center'

				initialX = initialX + 64
				doc.text 'Importe', initialX + 3 , initialY + 3 ,
						width: 45
						align: 'right'
				
				initial_Y = initialY + 8
				impuestosDetail = 0
				while impuestosDetail < 3
					initialX = 340
					doc.fontSize 9
						.font 'Helvetica'
						.text 'IVA', initialX + 3 , initial_Y + 5 ,
							width: 40
							align: 'left'

					initialX = initialX + 40
					doc.text 'Traslado', initialX + 3 , initial_Y + 5 ,
							width: 40
							align: 'center'

					initialX = initialX + 40
					doc.text 'Tasa', initialX + 3 , initial_Y + 5 ,
							width: 46
							align: 'center'

					initialX = initialX + 46
					doc.text '0.16000', initialX + 3 , initial_Y + 5 ,
							width: 56
							align: 'center'

					initialX = initialX + 56
					doc.text '1233.78', initialX + 3 , initial_Y + 5 ,
							width: 52
							align: 'right'

					initial_Y = initial_Y + 9
					impuestosDetail++
				initialY = initialY + 40
				conceptos++
				if doc.page.height < initialY + 100
					doc.addPage()
					initialY = firstInitialY
					if conceptos < qtyConceptos
						initialX = 40
						col = 0
						while col < tableTitle.length
							doc.rect initialX, initialY, tableTitle[col].ancho, 20
								.fillAndStroke colorBack,'black'
							doc.fillColor 'black'
								.text tableTitle[col].nombre, initialX, initialY+5,
									width: tableTitle[col].ancho
									align: 'center'
							initialX = initialX + parseInt(tableTitle[col].ancho)
							col++
						initialY = initialY + 20
			
			if initialY > 620
				doc.addPage()
				initialY = firstInitialY
			else
				initialY = initialY + 10
			initialX = 40
			interline = 18
			doc.fontSize fontTitle
				.font 'Helvetica-Bold'
				.text 'Moneda:', initialX, initialY
				.text 'Forma de Pago:', initialX, initialY+(interline*1.5)
				.text 'Método de Pago:', initialX, initialY+(interline*3)

			initialX = 125
			interline = 18
			doc.fontSize fontTitle
				.font 'Helvetica'
				.text 'Moneda:', initialX, initialY
				.text 'Forma de Pago:', initialX, initialY+(interline*1.5)
				.text 'Método de Pago:', initialX, initialY+(interline*3)			
			
			initialX = 340
			interline = 16
			doc.fontSize(fontTitle)
				.font('Helvetica-Bold')
				.text('Sub-Total:', initialX, initialY)
				.text('Impuestos Trasladados:', initialX, initialY+interline)
				.text('Impuestos Retenidos:', initialX, initialY+(interline*2))
				.text('Descuento:', initialX, initialY+(interline*3))
				.text('Total:', initialX, initialY+(interline*4))

			initialX = 460
			interline = 16
			doc.fontSize(fontTitle)
				.font('Helvetica')
				.text 'Sub-Total:', initialX, initialY
				.text 'Impuestos Trasladados:', initialX, initialY+interline
				.text 'Impuestos Retenidos:', initialX, initialY+(interline*2)
				.text 'Descuento:', initialX, initialY+(interline*3)
				.text 'Total:', initialX, initialY+(interline*4)

			if initialY > 505
					doc.addPage()
					initialY = firstInitialY
			else
				initialY = initialY + 70
			initialX = 40
			doc.fontSize fontTitle
				.font 'Helvetica-Bold'
				.text 'Sello Digital:', initialX, initialY
			doc.moveDown(0.2)
			doc.fontSize 8
				.font 'Helvetica'
				.text 'sdxQhqSNCQISxukeV4akCsiWUxLUM75dnsfWx0XyeqwnhxJzX118mjZZa9VJOA1bQaL1Pwir9PHxZWQkmylz4ITAfOXY4xNSkpA/5YgQZ7BfEPZGSCJFwydlFhiZbaLWPDp7lWykbw/Ib+1 UACr0UIDNvjI1+xbmRtD776SHsx4='
			doc.moveDown(0.2)	
			doc.fontSize fontTitle
				.font 'Helvetica-Bold'
				.text 'Sello Sat:'
			doc.moveDown(0.2)
			doc.fontSize 8
				.font 'Helvetica'
				.text 'TtqW5X2xMUD/C7U3Is+synnA5mH5PAtSE9e0nAImLRZtnRgw0kOoRYo7hc8LrTy4P0bu46m23FuSMC5JdErlpQRFYsJ4MIJaNsZmoOpW1y6UPDYWZB5Dkfrs8drrmbtk/2sjZnOZ5mBuHr5 n3zBidjWjJseys/YsL0MiyispioQxEKPBgYfsHhuv4hRt1ojnIEbaehZo0sfFkm0FS7apS9KitiGdsYhlzP1vJi2vksJ64cCsNsZumCwgkouUPMjpZe/0XD7v4NehwHEGqke/5faDF7ZwIjeLxRzW+sU VTXiGKeZvLiFyDjSGZRCCaxO4Yt5095GDWKEgVXyGIZBrKg=='

			#El código QR
			initialY =  doc.y
			doc.image('./tmp/qrCode.png', 40, doc.y, width: 120)

			initialX = 200
			initialY = initialY + 10
			doc.fontSize fontTitle
				.font 'Helvetica-Bold'
				.text 'Cadena Original:', initialX, initialY
			doc.moveDown(0.2)
			doc.fontSize 8
				.font 'Helvetica'
				.text '||1.1|34DCA481-4F16-4500-A82E-85ED4FD51D28|2018-03-05T12:20:15|SAT970701NN3|sdxQhqSNCQISxukeV4akCsiWUxLUM75dnsfWx0XyeqwnhxJ zX118mjZZa9VJOA1bQaL1Pwir9PHxZWQkmylz4ITAfOXY4xNSkpA/5YgQZ7BfEPZGSCJFwydlFhiZbaLWPDp7lWykbw/Ib+1UACr0UIDNvjI1+xbmRtD776 SHsx4=|00001000000403258748||'
			doc.moveDown(0.1)
			initialY = doc.y
			doc.fontSize fontTitle
				.font 'Helvetica-Bold'
				.text 'Nro Certificado:'
			doc.moveDown(0.1)
			doc.fontSize fontTitle
				.font 'Helvetica-Bold'
				.text 'RFCProvCert:'
			doc.moveDown(0.1)
			doc.fontSize fontTitle
				.font 'Helvetica-Bold'
				.text 'FechaTimbrado:'
			doc.fontSize fontTitle
				.font 'Helvetica'
				.text '00001000000403258748', initialX + 80 , initialY
			doc.moveDown(0.1)
			doc.fontSize fontTitle
				.font 'Helvetica'
				.text 'SAT970701NN3'
			doc.moveDown(0.1)
			doc.fontSize fontTitle
				.font 'Helvetica'
				.text '2018-03-05 12:20:15'
			doc.moveDown(0.1)

			initialX = 40
			doc.fontSize 9
				.font 'Helvetica'
				.text 'Este documento es una representación impresa de un CFDI', initialX, 730,
					align: 'center'

			doc.end()
		)	
