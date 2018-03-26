# über rails c ausführen
# lädt alles aus dem angegeben Ordner tmp/csv/{parameter}
# Im Moment angepasst auf Apotheke



class CsvImport

    attr_accessor :file_path

    def initialize(folder)
        self.file_path = "#{Rails.root}/tmp/csv/#{folder}"
    end

    def is_number? string
        true if Float(string) rescue false
    end

    def import_delivery_orders(company)
        get_all_files().each do |file|
            CSV.foreach(file, col_sep: ";", encoding: 'UTF-8') do |row|

                if is_number?(row[0].squish) # ignore header and validate customer_reference
                    order = Order.new
                    order.customer = Customer.customer_by_customer_reference(row[0].squish.to_i, company, row[1].squish, row[3].squish)
                    order.delivery_location = row[2].squish
                    order.duration_delivery = row[4].squish
                    order.capacity = 0
                    order.start_time = DateTime.now
                    order.end_time = DateTime.now + 8.hours
                    order.active = true
                    order.comment = ""
                    order.comment2 = ""
                    order.save!
                end
            end
        end
        # laden aller csv im ordner
        # iterrieren über element und gleichzeitiges schreiben der order
        # überprüfen, das keine Order doppelt ist (manche Zeitfenster enthalten gleiche oder ähnliche orders)

    end

    # import aus csv. vom typ pickup aus dem zuvor mitgegebenen folder
    def import_pickup_orders(company)

    end

    # import aus csv. vom typ php aus dem zuvor mitgegebenen folder
    def import_php_orders(company)

    end

    # Alle files aus folder einlesen
    def get_all_files()
        Dir[file_path + "/*"]# return of array
    end


end
