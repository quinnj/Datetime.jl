#Offset code
setoffset{n}(tz::Type{Offset{n}},secs,y,s) = 60000*n - (y < 1972 ? 0 : s == 60 ? leaps1(secs) : leaps(secs))
getoffset{n}(tz::Type{Offset{n}},secs) = 60000*n - leaps(secs)
getoffset_secs{n}(tz::Type{Offset{n}},secs) = 60000*n - leaps1(secs)
getabr{n}(tz::Type{Offset{n}},secs,y) = (nn = fld(abs(n),60); nnn = abs(n) % 60; string(sign(n) == 1 ? "+" : "-",_s(nn),":$(_s(nnn))"))
offset{T<:TimeZone}(tz::Type{T}) = fld(get(OFFSETS,tz,0),60000)
offset(tz::String) = offset(get(TIMEZONES,tz,Zone0))
#TimeZone code
#Define "ZoneX" for each zone_id in Olson tz database
for tz in (:Zone0  ,:Zone1  ,:Zone2  ,:Zone3  ,:Zone4  ,:Zone5  ,:Zone6  ,:Zone7  ,:Zone8  ,:Zone9  ,:Zone10 ,:Zone11 ,:Zone12 ,:Zone13 ,:Zone14 ,:Zone15 ,:Zone16 ,:Zone17 ,:Zone18 ,:Zone19 ,:Zone20 ,:Zone21 ,:Zone22 ,:Zone23 ,:Zone24 ,:Zone25 ,:Zone26 ,:Zone27 ,:Zone28 ,:Zone29 ,:Zone30 ,:Zone31 ,:Zone32 ,:Zone33 ,:Zone34 ,:Zone35 ,:Zone36 ,:Zone37 ,:Zone38 ,:Zone39 ,:Zone40 ,:Zone41 ,:Zone42 ,:Zone43 ,:Zone44 ,:Zone45 ,:Zone46 ,:Zone47 ,:Zone48 ,:Zone49 ,
		   :Zone50 ,:Zone51 ,:Zone52 ,:Zone53 ,:Zone54 ,:Zone55 ,:Zone56 ,:Zone57 ,:Zone58 ,:Zone59 ,:Zone60 ,:Zone61 ,:Zone62 ,:Zone63 ,:Zone64 ,:Zone65 ,:Zone66 ,:Zone67 ,:Zone68 ,:Zone69 ,:Zone70 ,:Zone71 ,:Zone72 ,:Zone73 ,:Zone74 ,:Zone75 ,:Zone76 ,:Zone77 ,:Zone78 ,:Zone79 ,:Zone80 ,:Zone81 ,:Zone82 ,:Zone83 ,:Zone84 ,:Zone85 ,:Zone86 ,:Zone87 ,:Zone88 ,:Zone89 ,:Zone90 ,:Zone91 ,:Zone92 ,:Zone93 ,:Zone94 ,:Zone95 ,:Zone96 ,:Zone97 ,:Zone98 ,:Zone99 ,
		   :Zone100,:Zone101,:Zone102,:Zone103,:Zone104,:Zone105,:Zone106,:Zone107,:Zone108,:Zone109,:Zone110,:Zone111,:Zone112,:Zone113,:Zone114,:Zone115,:Zone116,:Zone117,:Zone118,:Zone119,:Zone120,:Zone121,:Zone122,:Zone123,:Zone124,:Zone125,:Zone126,:Zone127,:Zone128,:Zone129,:Zone130,:Zone131,:Zone132,:Zone133,:Zone134,:Zone135,:Zone136,:Zone137,:Zone138,:Zone139,:Zone140,:Zone141,:Zone142,:Zone143,:Zone144,:Zone145,:Zone146,:Zone147,:Zone148,:Zone149,
		   :Zone150,:Zone151,:Zone152,:Zone153,:Zone154,:Zone155,:Zone156,:Zone157,:Zone158,:Zone159,:Zone160,:Zone161,:Zone162,:Zone163,:Zone164,:Zone165,:Zone166,:Zone167,:Zone168,:Zone169,:Zone170,:Zone171,:Zone172,:Zone173,:Zone174,:Zone175,:Zone176,:Zone177,:Zone178,:Zone179,:Zone180,:Zone181,:Zone182,:Zone183,:Zone184,:Zone185,:Zone186,:Zone187,:Zone188,:Zone189,:Zone190,:Zone191,:Zone192,:Zone193,:Zone194,:Zone195,:Zone196,:Zone197,:Zone198,:Zone199,
		   :Zone200,:Zone201,:Zone202,:Zone203,:Zone204,:Zone205,:Zone206,:Zone207,:Zone208,:Zone209,:Zone210,:Zone211,:Zone212,:Zone213,:Zone214,:Zone215,:Zone216,:Zone217,:Zone218,:Zone219,:Zone220,:Zone221,:Zone222,:Zone223,:Zone224,:Zone225,:Zone226,:Zone227,:Zone228,:Zone229,:Zone230,:Zone231,:Zone232,:Zone233,:Zone234,:Zone235,:Zone236,:Zone237,:Zone238,:Zone239,:Zone240,:Zone241,:Zone242,:Zone243,:Zone244,:Zone245,:Zone246,:Zone247,:Zone248,:Zone249,
		   :Zone250,:Zone251,:Zone252,:Zone253,:Zone254,:Zone255,:Zone256,:Zone257,:Zone258,:Zone259,:Zone260,:Zone261,:Zone262,:Zone263,:Zone264,:Zone265,:Zone266,:Zone267,:Zone268,:Zone269,:Zone270,:Zone271,:Zone272,:Zone273,:Zone274,:Zone275,:Zone276,:Zone277,:Zone278,:Zone279,:Zone280,:Zone281,:Zone282,:Zone283,:Zone284,:Zone285,:Zone286,:Zone287,:Zone288,:Zone289,:Zone290,:Zone291,:Zone292,:Zone293,:Zone294,:Zone295,:Zone296,:Zone297,:Zone298,:Zone299,
		   :Zone300,:Zone301,:Zone302,:Zone303,:Zone304,:Zone305,:Zone306,:Zone307,:Zone308,:Zone309,:Zone310,:Zone311,:Zone312,:Zone313,:Zone314,:Zone315,:Zone316,:Zone317,:Zone318,:Zone319,:Zone320,:Zone321,:Zone322,:Zone323,:Zone324,:Zone325,:Zone326,:Zone327,:Zone328,:Zone329,:Zone330,:Zone331,:Zone332,:Zone333,:Zone334,:Zone335,:Zone336,:Zone337,:Zone338,:Zone339,:Zone340,:Zone341,:Zone342,:Zone343,:Zone344,:Zone345,:Zone346,:Zone347,:Zone348,:Zone349,
		   :Zone350,:Zone351,:Zone352,:Zone353,:Zone354,:Zone355,:Zone356,:Zone357,:Zone358,:Zone359,:Zone360,:Zone361,:Zone362,:Zone363,:Zone364,:Zone365,:Zone366,:Zone367,:Zone368,:Zone369,:Zone370,:Zone371,:Zone372,:Zone373,:Zone374,:Zone375,:Zone376,:Zone377,:Zone378,:Zone379,:Zone380,:Zone381,:Zone382,:Zone383,:Zone384,:Zone385,:Zone386,:Zone387,:Zone388,:Zone389,:Zone390,:Zone391,:Zone392,:Zone393,:Zone394,:Zone395,:Zone396,:Zone397,:Zone398,:Zone399,
		   :Zone400,:Zone401,:Zone402,:Zone403,:Zone404,:Zone405,:Zone406,:Zone407,:Zone408,:Zone409,:Zone410,:Zone411,:Zone412,:Zone413,:Zone414,:Zone415,:Zone416,:Zone417,:Zone418)
	@eval abstract $tz <: TimeZone
end

#Setup retrieval dict for getting zone from standard name
const TIMEZONES = (ASCIIString=>DataType)["Etc/GMT"=>Zone0,"Etc/UTC"=>Zone0,"Etc/UCT"=>Zone0,"GMT"=>Zone0,"UTC"=>Zone0,"UCT"=>Zone0,"Etc/Universal"=>Zone0,"Universal"=>Zone0,"Etc/Zulu"=>Zone0,"Zulu"=>Zone0,
	"Europe/Andorra"=>Zone1,"Asia/Dubai"=>Zone2,"Asia/Kabul"=>Zone3,"America/Antigua"=>Zone4,"America/Anguilla"=>Zone5,"Europe/Tirane"=>Zone6,"Asia/Yerevan"=>Zone7,"Africa/Luanda"=>Zone8,"Antarctica/McMurdo"=>Zone9,"Antarctica/South_Pole"=>Zone10,"Antarctica/Rothera"=>Zone11,"Antarctica/Palmer"=>Zone12,"Antarctica/Mawson"=>Zone13,"Antarctica/Davis"=>Zone14,"Antarctica/Casey"=>Zone15,"Antarctica/Vostok"=>Zone16,"Antarctica/DumontDUrville"=>Zone17,"Antarctica/Syowa"=>Zone18,"America/Argentina/Buenos_Aires"=>Zone19,"America/Argentina/Cordoba"=>Zone20,"America/Argentina/Salta"=>Zone21,"America/Argentina/Jujuy"=>Zone22,"America/Argentina/Tucuman"=>Zone23,"America/Argentina/Catamarca"=>Zone24,"America/Argentina/La_Rioja"=>Zone25,"America/Argentina/San_Juan"=>Zone26,"America/Argentina/Mendoza"=>Zone27,"America/Argentina/San_Luis"=>Zone28,"America/Argentina/Rio_Gallegos"=>Zone29,"America/Argentina/Ushuaia"=>Zone30,"Pacific/Pago_Pago"=>Zone31,"Europe/Vienna"=>Zone32,"Australia/Lord_Howe"=>Zone33,"Antarctica/Macquarie"=>Zone34,"Australia/Hobart"=>Zone35,"Australia/Currie"=>Zone36,"Australia/Melbourne"=>Zone37,"Australia/Sydney"=>Zone38,"Australia/Broken_Hill"=>Zone39,"Australia/Brisbane"=>Zone40,"Australia/Lindeman"=>Zone41,"Australia/Adelaide"=>Zone42,"Australia/Darwin"=>Zone43,"Australia/Perth"=>Zone44,"Australia/Eucla"=>Zone45,"America/Aruba"=>Zone46,"Europe/Mariehamn"=>Zone47,"Asia/Baku"=>Zone48,"Europe/Sarajevo"=>Zone49,
	"America/Barbados"=>Zone50,"Asia/Dhaka"=>Zone51,"Europe/Brussels"=>Zone52,"Africa/Ouagadougou"=>Zone53,"Europe/Sofia"=>Zone54,"Asia/Bahrain"=>Zone55,"Africa/Bujumbura"=>Zone56,"Africa/Porto-Novo"=>Zone57,"America/St_Barthelemy"=>Zone58,"Atlantic/Bermuda"=>Zone59,"Asia/Brunei"=>Zone60,"America/La_Paz"=>Zone61,"America/Kralendijk"=>Zone62,"America/Noronha"=>Zone63,"America/Belem"=>Zone64,"America/Fortaleza"=>Zone65,"America/Recife"=>Zone66,"America/Araguaina"=>Zone67,"America/Maceio"=>Zone68,"America/Bahia"=>Zone69,"America/Sao_Paulo"=>Zone70,"America/Campo_Grande"=>Zone71,"America/Cuiaba"=>Zone72,"America/Santarem"=>Zone73,"America/Porto_Velho"=>Zone74,"America/Boa_Vista"=>Zone75,"America/Manaus"=>Zone76,"America/Eirunepe"=>Zone77,"America/Rio_Branco"=>Zone78,"America/Nassau"=>Zone79,"Asia/Thimphu"=>Zone80,"Africa/Gaborone"=>Zone81,"Europe/Minsk"=>Zone82,"America/Belize"=>Zone83,"America/St_Johns"=>Zone84,"America/Halifax"=>Zone85,"America/Glace_Bay"=>Zone86,"America/Moncton"=>Zone87,"America/Goose_Bay"=>Zone88,"America/Blanc-Sablon"=>Zone89,"America/Montreal"=>Zone90,"America/Toronto"=>Zone91,"America/Nipigon"=>Zone92,"America/Thunder_Bay"=>Zone93,"America/Iqaluit"=>Zone94,"America/Pangnirtung"=>Zone95,"America/Resolute"=>Zone96,"America/Atikokan"=>Zone97,"America/Rankin_Inlet"=>Zone98,"America/Winnipeg"=>Zone99,
	"America/Rainy_River"=>Zone100,"America/Regina"=>Zone101,"America/Swift_Current"=>Zone102,"America/Edmonton"=>Zone103,"America/Cambridge_Bay"=>Zone104,"America/Yellowknife"=>Zone105,"America/Inuvik"=>Zone106,"America/Creston"=>Zone107,"America/Dawson_Creek"=>Zone108,"America/Vancouver"=>Zone109,"America/Whitehorse"=>Zone110,"America/Dawson"=>Zone111,"Indian/Cocos"=>Zone112,"Africa/Kinshasa"=>Zone113,"Africa/Lubumbashi"=>Zone114,"Africa/Bangui"=>Zone115,"Africa/Brazzaville"=>Zone116,"Europe/Zurich"=>Zone117,"Africa/Abidjan"=>Zone118,"Pacific/Rarotonga"=>Zone119,"America/Santiago"=>Zone120,"Pacific/Easter"=>Zone121,"Africa/Douala"=>Zone122,"Asia/Shanghai"=>Zone123,"Asia/Harbin"=>Zone124,"Asia/Chongqing"=>Zone125,"Asia/Urumqi"=>Zone126,"Asia/Kashgar"=>Zone127,"America/Bogota"=>Zone128,"America/Costa_Rica"=>Zone129,"America/Havana"=>Zone130,"Atlantic/Cape_Verde"=>Zone131,"America/Curacao"=>Zone132,"Indian/Christmas"=>Zone133,"Asia/Nicosia"=>Zone134,"Europe/Prague"=>Zone135,"Europe/Berlin"=>Zone136,"Europe/Busingen"=>Zone137,"Africa/Djibouti"=>Zone138,"Europe/Copenhagen"=>Zone139,"America/Dominica"=>Zone140,"America/Santo_Domingo"=>Zone141,"Africa/Algiers"=>Zone142,"America/Guayaquil"=>Zone143,"Pacific/Galapagos"=>Zone144,"Europe/Tallinn"=>Zone145,"Africa/Cairo"=>Zone146,"Africa/El_Aaiun"=>Zone147,"Africa/Asmara"=>Zone148,"Europe/Madrid"=>Zone149,
	"Africa/Ceuta"=>Zone150,"Atlantic/Canary"=>Zone151,"Africa/Addis_Ababa"=>Zone152,"Europe/Helsinki"=>Zone153,"Pacific/Fiji"=>Zone154,"Atlantic/Stanley"=>Zone155,"Pacific/Chuuk"=>Zone156,"Pacific/Pohnpei"=>Zone157,"Pacific/Kosrae"=>Zone158,"Atlantic/Faroe"=>Zone159,"Europe/Paris"=>Zone160,"Africa/Libreville"=>Zone161,"Europe/London"=>Zone162,"America/Grenada"=>Zone163,"Asia/Tbilisi"=>Zone164,"America/Cayenne"=>Zone165,"Europe/Guernsey"=>Zone166,"Africa/Accra"=>Zone167,"Europe/Gibraltar"=>Zone168,"America/Godthab"=>Zone169,"America/Danmarkshavn"=>Zone170,"America/Scoresbysund"=>Zone171,"America/Thule"=>Zone172,"Africa/Banjul"=>Zone173,"Africa/Conakry"=>Zone174,"America/Guadeloupe"=>Zone175,"Africa/Malabo"=>Zone176,"Europe/Athens"=>Zone177,"Atlantic/South_Georgia"=>Zone178,"America/Guatemala"=>Zone179,"Pacific/Guam"=>Zone180,"Africa/Bissau"=>Zone181,"America/Guyana"=>Zone182,"Asia/Hong_Kong"=>Zone183,"America/Tegucigalpa"=>Zone184,"Europe/Zagreb"=>Zone185,"America/Port-au-Prince"=>Zone186,"Europe/Budapest"=>Zone187,"Asia/Jakarta"=>Zone188,"Asia/Pontianak"=>Zone189,"Asia/Makassar"=>Zone190,"Asia/Jayapura"=>Zone191,"Europe/Dublin"=>Zone192,"Asia/Jerusalem"=>Zone193,"Europe/Isle_of_Man"=>Zone194,"Asia/Kolkata"=>Zone195,"Indian/Chagos"=>Zone196,"Asia/Baghdad"=>Zone197,"Asia/Tehran"=>Zone198,"Atlantic/Reykjavik"=>Zone199,
	"Europe/Rome"=>Zone200,"Europe/Jersey"=>Zone201,"America/Jamaica"=>Zone202,"Asia/Amman"=>Zone203,"Asia/Tokyo"=>Zone204,"Africa/Nairobi"=>Zone205,"Asia/Bishkek"=>Zone206,"Asia/Phnom_Penh"=>Zone207,"Pacific/Tarawa"=>Zone208,"Pacific/Enderbury"=>Zone209,"Pacific/Kiritimati"=>Zone210,"Indian/Comoro"=>Zone211,"America/St_Kitts"=>Zone212,"Asia/Pyongyang"=>Zone213,"Asia/Seoul"=>Zone214,"Asia/Kuwait"=>Zone215,"America/Cayman"=>Zone216,"Asia/Almaty"=>Zone217,"Asia/Qyzylorda"=>Zone218,"Asia/Aqtobe"=>Zone219,"Asia/Aqtau"=>Zone220,"Asia/Oral"=>Zone221,"Asia/Vientiane"=>Zone222,"Asia/Beirut"=>Zone223,"America/St_Lucia"=>Zone224,"Europe/Vaduz"=>Zone225,"Asia/Colombo"=>Zone226,"Africa/Monrovia"=>Zone227,"Africa/Maseru"=>Zone228,"Europe/Vilnius"=>Zone229,"Europe/Luxembourg"=>Zone230,"Europe/Riga"=>Zone231,"Africa/Tripoli"=>Zone232,"Africa/Casablanca"=>Zone233,"Europe/Monaco"=>Zone234,"Europe/Chisinau"=>Zone235,"Europe/Podgorica"=>Zone236,"America/Marigot"=>Zone237,"Indian/Antananarivo"=>Zone238,"Pacific/Majuro"=>Zone239,"Pacific/Kwajalein"=>Zone240,"Europe/Skopje"=>Zone241,"Africa/Bamako"=>Zone242,"Asia/Rangoon"=>Zone243,"Asia/Ulaanbaatar"=>Zone244,"Asia/Hovd"=>Zone245,"Asia/Choibalsan"=>Zone246,"Asia/Macau"=>Zone247,"Pacific/Saipan"=>Zone248,"America/Martinique"=>Zone249,
	"Africa/Nouakchott"=>Zone250,"America/Montserrat"=>Zone251,"Europe/Malta"=>Zone252,"Indian/Mauritius"=>Zone253,"Indian/Maldives"=>Zone254,"Africa/Blantyre"=>Zone255,"America/Mexico_City"=>Zone256,"America/Cancun"=>Zone257,"America/Merida"=>Zone258,"America/Monterrey"=>Zone259,"America/Matamoros"=>Zone260,"America/Mazatlan"=>Zone261,"America/Chihuahua"=>Zone262,"America/Ojinaga"=>Zone263,"America/Hermosillo"=>Zone264,"America/Tijuana"=>Zone265,"America/Santa_Isabel"=>Zone266,"America/Bahia_Banderas"=>Zone267,"Asia/Kuala_Lumpur"=>Zone268,"Asia/Kuching"=>Zone269,"Africa/Maputo"=>Zone270,"Africa/Windhoek"=>Zone271,"Pacific/Noumea"=>Zone272,"Africa/Niamey"=>Zone273,"Pacific/Norfolk"=>Zone274,"Africa/Lagos"=>Zone275,"America/Managua"=>Zone276,"Europe/Amsterdam"=>Zone277,"Europe/Oslo"=>Zone278,"Asia/Kathmandu"=>Zone279,"Pacific/Nauru"=>Zone280,"Pacific/Niue"=>Zone281,"Pacific/Auckland"=>Zone282,"Pacific/Chatham"=>Zone283,"Asia/Muscat"=>Zone284,"America/Panama"=>Zone285,"America/Lima"=>Zone286,"Pacific/Tahiti"=>Zone287,"Pacific/Marquesas"=>Zone288,"Pacific/Gambier"=>Zone289,"Pacific/Port_Moresby"=>Zone290,"Asia/Manila"=>Zone291,"Asia/Karachi"=>Zone292,"Europe/Warsaw"=>Zone293,"America/Miquelon"=>Zone294,"Pacific/Pitcairn"=>Zone295,"America/Puerto_Rico"=>Zone296,"Asia/Gaza"=>Zone297,"Asia/Hebron"=>Zone298,"Europe/Lisbon"=>Zone299,
	"Atlantic/Madeira"=>Zone300,"Atlantic/Azores"=>Zone301,"Pacific/Palau"=>Zone302,"America/Asuncion"=>Zone303,"Asia/Qatar"=>Zone304,"Indian/Reunion"=>Zone305,"Europe/Bucharest"=>Zone306,"Europe/Belgrade"=>Zone307,"Europe/Kaliningrad"=>Zone308,"Europe/Moscow"=>Zone309,"Europe/Volgograd"=>Zone310,"Europe/Samara"=>Zone311,"Asia/Yekaterinburg"=>Zone312,"Asia/Omsk"=>Zone313,"Asia/Novosibirsk"=>Zone314,"Asia/Novokuznetsk"=>Zone315,"Asia/Krasnoyarsk"=>Zone316,"Asia/Irkutsk"=>Zone317,"Asia/Yakutsk"=>Zone318,"Asia/Khandyga"=>Zone319,"Asia/Vladivostok"=>Zone320,"Asia/Sakhalin"=>Zone321,"Asia/Ust-Nera"=>Zone322,"Asia/Magadan"=>Zone323,"Asia/Kamchatka"=>Zone324,"Asia/Anadyr"=>Zone325,"Africa/Kigali"=>Zone326,"Asia/Riyadh"=>Zone327,"Pacific/Guadalcanal"=>Zone328,"Indian/Mahe"=>Zone329,"Africa/Khartoum"=>Zone330,"Europe/Stockholm"=>Zone331,"Asia/Singapore"=>Zone332,"Atlantic/St_Helena"=>Zone333,"Europe/Ljubljana"=>Zone334,"Arctic/Longyearbyen"=>Zone335,"Europe/Bratislava"=>Zone336,"Africa/Freetown"=>Zone337,"Europe/San_Marino"=>Zone338,"Africa/Dakar"=>Zone339,"Africa/Mogadishu"=>Zone340,"America/Paramaribo"=>Zone341,"Africa/Juba"=>Zone342,"Africa/Sao_Tome"=>Zone343,"America/El_Salvador"=>Zone344,"America/Lower_Princes"=>Zone345,"Asia/Damascus"=>Zone346,"Africa/Mbabane"=>Zone347,"America/Grand_Turk"=>Zone348,"Africa/Ndjamena"=>Zone349,
	"Indian/Kerguelen"=>Zone350,"Africa/Lome"=>Zone351,"Asia/Bangkok"=>Zone352,"Asia/Dushanbe"=>Zone353,"Pacific/Fakaofo"=>Zone354,"Asia/Dili"=>Zone355,"Asia/Ashgabat"=>Zone356,"Africa/Tunis"=>Zone357,"Pacific/Tongatapu"=>Zone358,"Europe/Istanbul"=>Zone359,"America/Port_of_Spain"=>Zone360,"Pacific/Funafuti"=>Zone361,"Asia/Taipei"=>Zone362,"Africa/Dar_es_Salaam"=>Zone363,"Europe/Kiev"=>Zone364,"Europe/Uzhgorod"=>Zone365,"Europe/Zaporozhye"=>Zone366,"Europe/Simferopol"=>Zone367,"Africa/Kampala"=>Zone368,"Pacific/Johnston"=>Zone369,"Pacific/Midway"=>Zone370,"Pacific/Wake"=>Zone371,"America/New_York"=>Zone372,"America/Detroit"=>Zone373,"America/Kentucky/Louisville"=>Zone374,"America/Kentucky/Monticello"=>Zone375,"America/Indiana/Indianapolis"=>Zone376,"America/Indiana/Vincennes"=>Zone377,"America/Indiana/Winamac"=>Zone378,"America/Indiana/Marengo"=>Zone379,"America/Indiana/Petersburg"=>Zone380,"America/Indiana/Vevay"=>Zone381,"America/Chicago"=>Zone382,"America/Indiana/Tell_City"=>Zone383,"America/Indiana/Knox"=>Zone384,"America/Menominee"=>Zone385,"America/North_Dakota/Center"=>Zone386,"America/North_Dakota/New_Salem"=>Zone387,"America/North_Dakota/Beulah"=>Zone388,"America/Denver"=>Zone389,"America/Boise"=>Zone390,"America/Shiprock"=>Zone391,"America/Phoenix"=>Zone392,"America/Los_Angeles"=>Zone393,"America/Anchorage"=>Zone394,"America/Juneau"=>Zone395,"America/Sitka"=>Zone396,"America/Yakutat"=>Zone397,"America/Nome"=>Zone398,"America/Adak"=>Zone399,
	"America/Metlakatla"=>Zone400,"Pacific/Honolulu"=>Zone401,"America/Montevideo"=>Zone402,"Asia/Samarkand"=>Zone403,"Asia/Tashkent"=>Zone404,"Europe/Vatican"=>Zone405,"America/St_Vincent"=>Zone406,"America/Caracas"=>Zone407,"America/Tortola"=>Zone408,"America/St_Thomas"=>Zone409,"Asia/Ho_Chi_Minh"=>Zone410,"Pacific/Efate"=>Zone411,"Pacific/Wallis"=>Zone412,"Pacific/Apia"=>Zone413,"Asia/Aden"=>Zone414,"Indian/Mayotte"=>Zone415,"Africa/Johannesburg"=>Zone416,"Africa/Lusaka"=>Zone417,"Africa/Harare"=>Zone418]

#Default standard-time offsets and abbreviations
const OFFSETS = (DataType=>Int)[Zone0=>0,Zone1=>3600000,Zone2=>14400000,Zone3=>16200000,Zone4=>-14400000,Zone5=>-14400000,Zone6=>3600000,Zone7=>14400000,Zone8=>3600000,Zone9=>46800000,Zone10=>46800000,Zone11=>-10800000,Zone12=>-10800000,Zone13=>18000000,Zone14=>25200000,Zone15=>28800000,Zone16=>21600000,Zone17=>36000000,Zone18=>10800000,Zone19=>-10800000,Zone20=>-10800000,Zone21=>-10800000,Zone22=>-10800000,Zone23=>-10800000,Zone24=>-10800000,Zone25=>-10800000,Zone26=>-10800000,Zone27=>-10800000,Zone28=>-10800000,Zone29=>-10800000,Zone30=>-10800000,Zone31=>-39600000,Zone32=>3600000,Zone33=>39600000,Zone34=>39600000,Zone35=>39600000,Zone36=>39600000,Zone37=>39600000,Zone38=>39600000,Zone39=>37800000,Zone40=>36000000,Zone41=>36000000,Zone42=>37800000,Zone43=>34200000,Zone44=>28800000,Zone45=>35100000,Zone46=>-14400000,Zone47=>7200000,Zone48=>14400000,Zone49=>3600000,
	Zone50=>-14400000,Zone51=>21600000,Zone52=>3600000,Zone53=>0,Zone54=>7200000,Zone55=>10800000,Zone56=>7200000,Zone57=>3600000,Zone58=>-14400000,Zone59=>-14400000,Zone60=>28800000,Zone61=>-14400000,Zone62=>-14400000,Zone63=>-7200000,Zone64=>-10800000,Zone65=>-10800000,Zone66=>-10800000,Zone67=>-7200000,Zone68=>-10800000,Zone69=>-10800000,Zone70=>-7200000,Zone71=>-10800000,Zone72=>-10800000,Zone73=>-10800000,Zone74=>-14400000,Zone75=>-14400000,Zone76=>-14400000,Zone77=>-14400000,Zone78=>-14400000,Zone79=>-18000000,Zone80=>21600000,Zone81=>7200000,Zone82=>10800000,Zone83=>-21600000,Zone84=>-12600000,Zone85=>-14400000,Zone86=>-14400000,Zone87=>-14400000,Zone88=>-14400000,Zone89=>-14400000,Zone90=>-18000000,Zone91=>-18000000,Zone92=>-18000000,Zone93=>-18000000,Zone94=>-18000000,Zone95=>-18000000,Zone96=>-21600000,Zone97=>-18000000,Zone98=>-21600000,Zone99=>-21600000,
	Zone100=>-21600000,Zone101=>-21600000,Zone102=>-21600000,Zone103=>-25200000,Zone104=>-25200000,Zone105=>-25200000,Zone106=>-25200000,Zone107=>-25200000,Zone108=>-25200000,Zone109=>-28800000,Zone110=>-28800000,Zone111=>-28800000,Zone112=>23400000,Zone113=>3600000,Zone114=>7200000,Zone115=>3600000,Zone116=>3600000,Zone117=>3600000,Zone118=>0,Zone119=>-36000000,Zone120=>-10800000,Zone121=>-18000000,Zone122=>3600000,Zone123=>28800000,Zone124=>28800000,Zone125=>28800000,Zone126=>28800000,Zone127=>28800000,Zone128=>-18000000,Zone129=>-21600000,Zone130=>-18000000,Zone131=>-3600000,Zone132=>-14400000,Zone133=>25200000,Zone134=>7200000,Zone135=>3600000,Zone136=>3600000,Zone137=>3600000,Zone138=>10800000,Zone139=>3600000,Zone140=>-14400000,Zone141=>-14400000,Zone142=>3600000,Zone143=>-18000000,Zone144=>-21600000,Zone145=>7200000,Zone146=>7200000,Zone147=>0,Zone148=>10800000,Zone149=>3600000,
	Zone150=>3600000,Zone151=>0,Zone152=>10800000,Zone153=>7200000,Zone154=>46800000,Zone155=>-10800000,Zone156=>36000000,Zone157=>39600000,Zone158=>39600000,Zone159=>0,Zone160=>3600000,Zone161=>3600000,Zone162=>0,Zone163=>-14400000,Zone164=>14400000,Zone165=>-10800000,Zone166=>0,Zone167=>0,Zone168=>3600000,Zone169=>-10800000,Zone170=>0,Zone171=>-3600000,Zone172=>-14400000,Zone173=>0,Zone174=>0,Zone175=>-14400000,Zone176=>3600000,Zone177=>7200000,Zone178=>-7200000,Zone179=>-21600000,Zone180=>36000000,Zone181=>0,Zone182=>-14400000,Zone183=>28800000,Zone184=>-21600000,Zone185=>3600000,Zone186=>-18000000,Zone187=>3600000,Zone188=>25200000,Zone189=>25200000,Zone190=>28800000,Zone191=>32400000,Zone192=>0,Zone193=>7200000,Zone194=>0,Zone195=>19800000,Zone196=>21600000,Zone197=>10800000,Zone198=>12600000,Zone199=>0,
	Zone200=>3600000,Zone201=>0,Zone202=>-18000000,Zone203=>7200000,Zone204=>32400000,Zone205=>10800000,Zone206=>21600000,Zone207=>25200000,Zone208=>43200000,Zone209=>46800000,Zone210=>50400000,Zone211=>10800000,Zone212=>-14400000,Zone213=>32400000,Zone214=>32400000,Zone215=>10800000,Zone216=>-18000000,Zone217=>21600000,Zone218=>21600000,Zone219=>18000000,Zone220=>18000000,Zone221=>18000000,Zone222=>25200000,Zone223=>7200000,Zone224=>-14400000,Zone225=>3600000,Zone226=>19800000,Zone227=>0,Zone228=>7200000,Zone229=>7200000,Zone230=>3600000,Zone231=>7200000,Zone232=>3600000,Zone233=>0,Zone234=>3600000,Zone235=>7200000,Zone236=>3600000,Zone237=>-14400000,Zone238=>10800000,Zone239=>43200000,Zone240=>43200000,Zone241=>3600000,Zone242=>0,Zone243=>23400000,Zone244=>28800000,Zone245=>25200000,Zone246=>28800000,Zone247=>28800000,Zone248=>36000000,Zone249=>-14400000,
	Zone250=>0,Zone251=>-14400000,Zone252=>3600000,Zone253=>14400000,Zone254=>18000000,Zone255=>7200000,Zone256=>-21600000,Zone257=>-21600000,Zone258=>-21600000,Zone259=>-21600000,Zone260=>-21600000,Zone261=>-25200000,Zone262=>-25200000,Zone263=>-25200000,Zone264=>-25200000,Zone265=>-28800000,Zone266=>-28800000,Zone267=>-21600000,Zone268=>28800000,Zone269=>28800000,Zone270=>7200000,Zone271=>7200000,Zone272=>39600000,Zone273=>3600000,Zone274=>41400000,Zone275=>3600000,Zone276=>-21600000,Zone277=>3600000,Zone278=>3600000,Zone279=>20476000,Zone280=>43200000,Zone281=>-39600000,Zone282=>46800000,Zone283=>49500000,Zone284=>14400000,Zone285=>-18000000,Zone286=>-18000000,Zone287=>-36000000,Zone288=>-34200000,Zone289=>-32400000,Zone290=>36000000,Zone291=>28800000,Zone292=>18000000,Zone293=>3600000,Zone294=>-10800000,Zone295=>-28800000,Zone296=>-14400000,Zone297=>7200000,Zone298=>7200000,Zone299=>0,
	Zone300=>0,Zone301=>-3600000,Zone302=>32400000,Zone303=>-10800000,Zone304=>10800000,Zone305=>14400000,Zone306=>7200000,Zone307=>3600000,Zone308=>10800000,Zone309=>14400000,Zone310=>14400000,Zone311=>14400000,Zone312=>21600000,Zone313=>25200000,Zone314=>25200000,Zone315=>25200000,Zone316=>28800000,Zone317=>32400000,Zone318=>36000000,Zone319=>36000000,Zone320=>39600000,Zone321=>39600000,Zone322=>39600000,Zone323=>43200000,Zone324=>43200000,Zone325=>43200000,Zone326=>7200000,Zone327=>10800000,Zone328=>39600000,Zone329=>14400000,Zone330=>10800000,Zone331=>3600000,Zone332=>28800000,Zone333=>0,Zone334=>3600000,Zone335=>3600000,Zone336=>3600000,Zone337=>0,Zone338=>3600000,Zone339=>0,Zone340=>10800000,Zone341=>-10800000,Zone342=>10800000,Zone343=>0,Zone344=>-21600000,Zone345=>-14400000,Zone346=>7200000,Zone347=>7200000,Zone348=>-18000000,Zone349=>3600000,
	Zone350=>18000000,Zone351=>0,Zone352=>25200000,Zone353=>18000000,Zone354=>46800000,Zone355=>32400000,Zone356=>18000000,Zone357=>3600000,Zone358=>46800000,Zone359=>7200000,Zone360=>-14400000,Zone361=>43200000,Zone362=>28800000,Zone363=>10800000,Zone364=>7200000,Zone365=>7200000,Zone366=>7200000,Zone367=>7200000,Zone368=>10800000,Zone369=>-36000000,Zone370=>-39600000,Zone371=>43200000,Zone372=>-18000000,Zone373=>-18000000,Zone374=>-18000000,Zone375=>-18000000,Zone376=>-18000000,Zone377=>-18000000,Zone378=>-18000000,Zone379=>-18000000,Zone380=>-18000000,Zone381=>-18000000,Zone382=>-21600000,Zone383=>-21600000,Zone384=>-21600000,Zone385=>-21600000,Zone386=>-21600000,Zone387=>-21600000,Zone388=>-21600000,Zone389=>-25200000,Zone390=>-25200000,Zone391=>-25200000,Zone392=>-25200000,Zone393=>-28800000,Zone394=>-32400000,Zone395=>-32400000,Zone396=>-32400000,Zone397=>-32400000,Zone398=>-32400000,Zone399=>-36000000,
	Zone400=>-28800000,Zone401=>-36000000,Zone402=>-7200000,Zone403=>18000000,Zone404=>18000000,Zone405=>3600000,Zone406=>-14400000,Zone407=>-16200000,Zone408=>-14400000,Zone409=>-14400000,Zone410=>25200000,Zone411=>39600000,Zone412=>43200000,Zone413=>50400000,Zone414=>10800000,Zone415=>10800000,Zone416=>7200000,Zone417=>7200000,Zone418=>7200000]

const ABBREVIATIONS = (DataType=>ASCIIString)[Zone0=>"UTC",Zone1=>"CET",Zone2=>"GST",Zone3=>"AFT",Zone4=>"AST",Zone5=>"AST",Zone6=>"CET",Zone7=>"AMT",Zone8=>"WAT",Zone9=>"NZDT",Zone10=>"NZDT",Zone11=>"ROTT",Zone12=>"CLST",Zone13=>"MAWT",Zone14=>"DAVT",Zone15=>"WST",Zone16=>"VOST",Zone17=>"DDUT",Zone18=>"SYOT",Zone19=>"ART",Zone20=>"ART",Zone21=>"ART",Zone22=>"ART",Zone23=>"ART",Zone24=>"ART",Zone25=>"ART",Zone26=>"ART",Zone27=>"ART",Zone28=>"WARST",Zone29=>"ART",Zone30=>"ART",Zone31=>"SST",Zone32=>"CET",Zone33=>"LHST",Zone34=>"MIST",Zone35=>"EST",Zone36=>"EST",Zone37=>"EST",Zone38=>"EST",Zone39=>"CST",Zone40=>"EST",Zone41=>"EST",Zone42=>"CST",Zone43=>"CST",Zone44=>"WST",Zone45=>"CWST",Zone46=>"AST",Zone47=>"EET",Zone48=>"AZT",Zone49=>"CET",
	Zone50=>"AST",Zone51=>"BDT",Zone52=>"CET",Zone53=>"GMT",Zone54=>"EET",Zone55=>"AST",Zone56=>"CAT",Zone57=>"WAT",Zone58=>"AST",Zone59=>"AST",Zone60=>"BNT",Zone61=>"BOT",Zone62=>"AST",Zone63=>"FNT",Zone64=>"BRT",Zone65=>"BRT",Zone66=>"BRT",Zone67=>"BRST",Zone68=>"BRT",Zone69=>"BRT",Zone70=>"BRST",Zone71=>"AMST",Zone72=>"AMST",Zone73=>"BRT",Zone74=>"AMT",Zone75=>"AMT",Zone76=>"AMT",Zone77=>"AMT",Zone78=>"AMT",Zone79=>"EST",Zone80=>"BTT",Zone81=>"CAT",Zone82=>"FET",Zone83=>"CST",Zone84=>"NST",Zone85=>"AST",Zone86=>"AST",Zone87=>"AST",Zone88=>"AST",Zone89=>"AST",Zone90=>"EST",Zone91=>"EST",Zone92=>"EST",Zone93=>"EST",Zone94=>"EST",Zone95=>"EST",Zone96=>"CST",Zone97=>"EST",Zone98=>"CST",Zone99=>"CST",
	Zone100=>"CST",Zone101=>"CST",Zone102=>"CST",Zone103=>"MST",Zone104=>"MST",Zone105=>"MST",Zone106=>"MST",Zone107=>"MST",Zone108=>"MST",Zone109=>"PST",Zone110=>"PST",Zone111=>"PST",Zone112=>"CCT",Zone113=>"WAT",Zone114=>"CAT",Zone115=>"WAT",Zone116=>"WAT",Zone117=>"CET",Zone118=>"GMT",Zone119=>"CKT",Zone120=>"CLST",Zone121=>"EASST",Zone122=>"WAT",Zone123=>"CST",Zone124=>"CST",Zone125=>"CST",Zone126=>"CST",Zone127=>"CST",Zone128=>"COT",Zone129=>"CST",Zone130=>"CST",Zone131=>"CVT",Zone132=>"AST",Zone133=>"CXT",Zone134=>"EET",Zone135=>"CET",Zone136=>"CET",Zone137=>"CET",Zone138=>"EAT",Zone139=>"CET",Zone140=>"AST",Zone141=>"AST",Zone142=>"CET",Zone143=>"ECT",Zone144=>"GALT",Zone145=>"EET",Zone146=>"EET",Zone147=>"WET",Zone148=>"EAT",Zone149=>"CET",
	Zone150=>"CET",Zone151=>"WET",Zone152=>"EAT",Zone153=>"EET",Zone154=>"FJST",Zone155=>"FKST",Zone156=>"CHUT",Zone157=>"PONT",Zone158=>"KOST",Zone159=>"WET",Zone160=>"CET",Zone161=>"WAT",Zone162=>"GMT",Zone163=>"AST",Zone164=>"GET",Zone165=>"GFT",Zone166=>"GMT",Zone167=>"GMT",Zone168=>"CET",Zone169=>"WGT",Zone170=>"GMT",Zone171=>"EGT",Zone172=>"AST",Zone173=>"GMT",Zone174=>"GMT",Zone175=>"AST",Zone176=>"WAT",Zone177=>"EET",Zone178=>"GST",Zone179=>"CST",Zone180=>"ChST",Zone181=>"GMT",Zone182=>"GYT",Zone183=>"HKT",Zone184=>"CST",Zone185=>"CET",Zone186=>"EST",Zone187=>"CET",Zone188=>"WIT",Zone189=>"WIT",Zone190=>"CIT",Zone191=>"EIT",Zone192=>"GMT",Zone193=>"IST",Zone194=>"GMT",Zone195=>"IST",Zone196=>"IOT",Zone197=>"AST",Zone198=>"IRST",Zone199=>"GMT",
	Zone200=>"CET",Zone201=>"GMT",Zone202=>"EST",Zone203=>"EET",Zone204=>"JST",Zone205=>"EAT",Zone206=>"KGT",Zone207=>"ICT",Zone208=>"GILT",Zone209=>"PHOT",Zone210=>"LINT",Zone211=>"EAT",Zone212=>"AST",Zone213=>"KST",Zone214=>"KST",Zone215=>"AST",Zone216=>"EST",Zone217=>"ALMT",Zone218=>"QYZT",Zone219=>"AQTT",Zone220=>"AQTT",Zone221=>"ORAT",Zone222=>"ICT",Zone223=>"EET",Zone224=>"AST",Zone225=>"CET",Zone226=>"IST",Zone227=>"GMT",Zone228=>"SAST",Zone229=>"EET",Zone230=>"CET",Zone231=>"EET",Zone232=>"CET",Zone233=>"WET",Zone234=>"CET",Zone235=>"EET",Zone236=>"CET",Zone237=>"AST",Zone238=>"EAT",Zone239=>"MHT",Zone240=>"MHT",Zone241=>"CET",Zone242=>"GMT",Zone243=>"MMT",Zone244=>"ULAT",Zone245=>"HOVT",Zone246=>"CHOT",Zone247=>"CST",Zone248=>"ChST",Zone249=>"AST",
	Zone250=>"GMT",Zone251=>"AST",Zone252=>"CET",Zone253=>"MUT",Zone254=>"MVT",Zone255=>"CAT",Zone256=>"CST",Zone257=>"CST",Zone258=>"CST",Zone259=>"CST",Zone260=>"CST",Zone261=>"MST",Zone262=>"MST",Zone263=>"MST",Zone264=>"MST",Zone265=>"PST",Zone266=>"PST",Zone267=>"CST",Zone268=>"MYT",Zone269=>"MYT",Zone270=>"CAT",Zone271=>"WAST",Zone272=>"NCT",Zone273=>"WAT",Zone274=>"NFT",Zone275=>"WAT",Zone276=>"CST",Zone277=>"CET",Zone278=>"CET",Zone279=>"LMT",Zone280=>"NRT",Zone281=>"NUT",Zone282=>"NZDT",Zone283=>"CHADT",Zone284=>"GST",Zone285=>"EST",Zone286=>"PET",Zone287=>"TAHT",Zone288=>"MART",Zone289=>"GAMT",Zone290=>"PGT",Zone291=>"PHT",Zone292=>"PKT",Zone293=>"CET",Zone294=>"PMST",Zone295=>"PST",Zone296=>"AST",Zone297=>"EET",Zone298=>"EET",Zone299=>"WET",
	Zone300=>"WET",Zone301=>"AZOT",Zone302=>"PWT",Zone303=>"PYST",Zone304=>"AST",Zone305=>"RET",Zone306=>"EET",Zone307=>"CET",Zone308=>"FET",Zone309=>"MSK",Zone310=>"VOLT",Zone311=>"SAMT",Zone312=>"YEKT",Zone313=>"OMST",Zone314=>"NOVT",Zone315=>"NOVT",Zone316=>"KRAT",Zone317=>"IRKT",Zone318=>"YAKT",Zone319=>"YAKT",Zone320=>"VLAT",Zone321=>"SAKT",Zone322=>"VLAT",Zone323=>"MAGT",Zone324=>"PETT",Zone325=>"ANAT",Zone326=>"CAT",Zone327=>"AST",Zone328=>"SBT",Zone329=>"SCT",Zone330=>"EAT",Zone331=>"CET",Zone332=>"SGT",Zone333=>"GMT",Zone334=>"CET",Zone335=>"CET",Zone336=>"CET",Zone337=>"GMT",Zone338=>"CET",Zone339=>"GMT",Zone340=>"EAT",Zone341=>"SRT",Zone342=>"EAT",Zone343=>"GMT",Zone344=>"CST",Zone345=>"AST",Zone346=>"EET",Zone347=>"SAST",Zone348=>"EST",Zone349=>"WAT",
	Zone350=>"TFT",Zone351=>"GMT",Zone352=>"ICT",Zone353=>"TJT",Zone354=>"TKT",Zone355=>"TLT",Zone356=>"TMT",Zone357=>"CET",Zone358=>"TOT",Zone359=>"EET",Zone360=>"AST",Zone361=>"TVT",Zone362=>"CST",Zone363=>"EAT",Zone364=>"EET",Zone365=>"EET",Zone366=>"EET",Zone367=>"EET",Zone368=>"EAT",Zone369=>"HST",Zone370=>"SST",Zone371=>"WAKT",Zone372=>"EST",Zone373=>"EST",Zone374=>"EST",Zone375=>"EST",Zone376=>"EST",Zone377=>"EST",Zone378=>"EST",Zone379=>"EST",Zone380=>"EST",Zone381=>"EST",Zone382=>"CST",Zone383=>"CST",Zone384=>"CST",Zone385=>"CST",Zone386=>"CST",Zone387=>"CST",Zone388=>"CST",Zone389=>"MST",Zone390=>"MST",Zone391=>"MST",Zone392=>"MST",Zone393=>"PST",Zone394=>"AKST",Zone395=>"AKST",Zone396=>"AKST",Zone397=>"AKST",Zone398=>"AKST",Zone399=>"HAST",
	Zone400=>"MeST",Zone401=>"HST",Zone402=>"UYST",Zone403=>"UZT",Zone404=>"UZT",Zone405=>"CET",Zone406=>"AST",Zone407=>"VET",Zone408=>"AST",Zone409=>"AST",Zone410=>"ICT",Zone411=>"VUT",Zone412=>"WFT",Zone413=>"WSDT",Zone414=>"AST",Zone415=>"EAT",Zone416=>"SAST",Zone417=>"CAT",Zone418=>"CAT"]

const DATAFILES = (DataType=>Symbol)[Zone1=>:Zone1DATA  ,Zone2=>:Zone2DATA  ,Zone3=>:Zone3DATA  ,Zone4=>:Zone4DATA  ,Zone5=>:Zone5DATA  ,Zone6=>:Zone6DATA  ,Zone7=>:Zone7DATA  ,Zone8=>:Zone8DATA  ,Zone9=>:Zone9DATA  ,Zone10=>:Zone10DATA ,Zone11=>:Zone11DATA ,Zone12=>:Zone12DATA ,Zone13=>:Zone13DATA ,Zone14=>:Zone14DATA ,Zone15=>:Zone15DATA ,Zone16=>:Zone16DATA ,Zone17=>:Zone17DATA ,Zone18=>:Zone18DATA ,Zone19=>:Zone19DATA ,Zone20=>:Zone20DATA ,Zone21=>:Zone21DATA ,Zone22=>:Zone22DATA ,Zone23=>:Zone23DATA ,Zone24=>:Zone24DATA ,Zone25=>:Zone25DATA ,Zone26=>:Zone26DATA ,Zone27=>:Zone27DATA ,Zone28=>:Zone28DATA ,Zone29=>:Zone29DATA ,Zone30=>:Zone30DATA ,Zone31=>:Zone31DATA ,Zone32=>:Zone32DATA ,Zone33=>:Zone33DATA ,Zone34=>:Zone34DATA ,Zone35=>:Zone35DATA ,Zone36=>:Zone36DATA ,Zone37=>:Zone37DATA ,Zone38=>:Zone38DATA ,Zone39=>:Zone39DATA ,Zone40=>:Zone40DATA ,Zone41=>:Zone41DATA ,Zone42=>:Zone42DATA ,Zone43=>:Zone43DATA ,Zone44=>:Zone44DATA ,Zone45=>:Zone45DATA ,Zone46=>:Zone46DATA ,Zone47=>:Zone47DATA ,Zone48=>:Zone48DATA ,Zone49=>:Zone49DATA ,
	Zone50=>:Zone50DATA ,Zone51=>:Zone51DATA ,Zone52=>:Zone52DATA ,Zone53=>:Zone53DATA ,Zone54=>:Zone54DATA ,Zone55=>:Zone55DATA ,Zone56=>:Zone56DATA ,Zone57=>:Zone57DATA ,Zone58=>:Zone58DATA ,Zone59=>:Zone59DATA ,Zone60=>:Zone60DATA ,Zone61=>:Zone61DATA ,Zone62=>:Zone62DATA ,Zone63=>:Zone63DATA ,Zone64=>:Zone64DATA ,Zone65=>:Zone65DATA ,Zone66=>:Zone66DATA ,Zone67=>:Zone67DATA ,Zone68=>:Zone68DATA ,Zone69=>:Zone69DATA ,Zone70=>:Zone70DATA ,Zone71=>:Zone71DATA ,Zone72=>:Zone72DATA ,Zone73=>:Zone73DATA ,Zone74=>:Zone74DATA ,Zone75=>:Zone75DATA ,Zone76=>:Zone76DATA ,Zone77=>:Zone77DATA ,Zone78=>:Zone78DATA ,Zone79=>:Zone79DATA ,Zone80=>:Zone80DATA ,Zone81=>:Zone81DATA ,Zone82=>:Zone82DATA ,Zone83=>:Zone83DATA ,Zone84=>:Zone84DATA ,Zone85=>:Zone85DATA ,Zone86=>:Zone86DATA ,Zone87=>:Zone87DATA ,Zone88=>:Zone88DATA ,Zone89=>:Zone89DATA ,Zone90=>:Zone90DATA ,Zone91=>:Zone91DATA ,Zone92=>:Zone92DATA ,Zone93=>:Zone93DATA ,Zone94=>:Zone94DATA ,Zone95=>:Zone95DATA ,Zone96=>:Zone96DATA ,Zone97=>:Zone97DATA ,Zone98=>:Zone98DATA ,Zone99=>:Zone99DATA ,
	Zone100=>:Zone100DATA,Zone101=>:Zone101DATA,Zone102=>:Zone102DATA,Zone103=>:Zone103DATA,Zone104=>:Zone104DATA,Zone105=>:Zone105DATA,Zone106=>:Zone106DATA,Zone107=>:Zone107DATA,Zone108=>:Zone108DATA,Zone109=>:Zone109DATA,Zone110=>:Zone110DATA,Zone111=>:Zone111DATA,Zone112=>:Zone112DATA,Zone113=>:Zone113DATA,Zone114=>:Zone114DATA,Zone115=>:Zone115DATA,Zone116=>:Zone116DATA,Zone117=>:Zone117DATA,Zone118=>:Zone118DATA,Zone119=>:Zone119DATA,Zone120=>:Zone120DATA,Zone121=>:Zone121DATA,Zone122=>:Zone122DATA,Zone123=>:Zone123DATA,Zone124=>:Zone124DATA,Zone125=>:Zone125DATA,Zone126=>:Zone126DATA,Zone127=>:Zone127DATA,Zone128=>:Zone128DATA,Zone129=>:Zone129DATA,Zone130=>:Zone130DATA,Zone131=>:Zone131DATA,Zone132=>:Zone132DATA,Zone133=>:Zone133DATA,Zone134=>:Zone134DATA,Zone135=>:Zone135DATA,Zone136=>:Zone136DATA,Zone137=>:Zone137DATA,Zone138=>:Zone138DATA,Zone139=>:Zone139DATA,Zone140=>:Zone140DATA,Zone141=>:Zone141DATA,Zone142=>:Zone142DATA,Zone143=>:Zone143DATA,Zone144=>:Zone144DATA,Zone145=>:Zone145DATA,Zone146=>:Zone146DATA,Zone147=>:Zone147DATA,Zone148=>:Zone148DATA,Zone149=>:Zone149DATA,
	Zone150=>:Zone150DATA,Zone151=>:Zone151DATA,Zone152=>:Zone152DATA,Zone153=>:Zone153DATA,Zone154=>:Zone154DATA,Zone155=>:Zone155DATA,Zone156=>:Zone156DATA,Zone157=>:Zone157DATA,Zone158=>:Zone158DATA,Zone159=>:Zone159DATA,Zone160=>:Zone160DATA,Zone161=>:Zone161DATA,Zone162=>:Zone162DATA,Zone163=>:Zone163DATA,Zone164=>:Zone164DATA,Zone165=>:Zone165DATA,Zone166=>:Zone166DATA,Zone167=>:Zone167DATA,Zone168=>:Zone168DATA,Zone169=>:Zone169DATA,Zone170=>:Zone170DATA,Zone171=>:Zone171DATA,Zone172=>:Zone172DATA,Zone173=>:Zone173DATA,Zone174=>:Zone174DATA,Zone175=>:Zone175DATA,Zone176=>:Zone176DATA,Zone177=>:Zone177DATA,Zone178=>:Zone178DATA,Zone179=>:Zone179DATA,Zone180=>:Zone180DATA,Zone181=>:Zone181DATA,Zone182=>:Zone182DATA,Zone183=>:Zone183DATA,Zone184=>:Zone184DATA,Zone185=>:Zone185DATA,Zone186=>:Zone186DATA,Zone187=>:Zone187DATA,Zone188=>:Zone188DATA,Zone189=>:Zone189DATA,Zone190=>:Zone190DATA,Zone191=>:Zone191DATA,Zone192=>:Zone192DATA,Zone193=>:Zone193DATA,Zone194=>:Zone194DATA,Zone195=>:Zone195DATA,Zone196=>:Zone196DATA,Zone197=>:Zone197DATA,Zone198=>:Zone198DATA,Zone199=>:Zone199DATA,
	Zone200=>:Zone200DATA,Zone201=>:Zone201DATA,Zone202=>:Zone202DATA,Zone203=>:Zone203DATA,Zone204=>:Zone204DATA,Zone205=>:Zone205DATA,Zone206=>:Zone206DATA,Zone207=>:Zone207DATA,Zone208=>:Zone208DATA,Zone209=>:Zone209DATA,Zone210=>:Zone210DATA,Zone211=>:Zone211DATA,Zone212=>:Zone212DATA,Zone213=>:Zone213DATA,Zone214=>:Zone214DATA,Zone215=>:Zone215DATA,Zone216=>:Zone216DATA,Zone217=>:Zone217DATA,Zone218=>:Zone218DATA,Zone219=>:Zone219DATA,Zone220=>:Zone220DATA,Zone221=>:Zone221DATA,Zone222=>:Zone222DATA,Zone223=>:Zone223DATA,Zone224=>:Zone224DATA,Zone225=>:Zone225DATA,Zone226=>:Zone226DATA,Zone227=>:Zone227DATA,Zone228=>:Zone228DATA,Zone229=>:Zone229DATA,Zone230=>:Zone230DATA,Zone231=>:Zone231DATA,Zone232=>:Zone232DATA,Zone233=>:Zone233DATA,Zone234=>:Zone234DATA,Zone235=>:Zone235DATA,Zone236=>:Zone236DATA,Zone237=>:Zone237DATA,Zone238=>:Zone238DATA,Zone239=>:Zone239DATA,Zone240=>:Zone240DATA,Zone241=>:Zone241DATA,Zone242=>:Zone242DATA,Zone243=>:Zone243DATA,Zone244=>:Zone244DATA,Zone245=>:Zone245DATA,Zone246=>:Zone246DATA,Zone247=>:Zone247DATA,Zone248=>:Zone248DATA,Zone249=>:Zone249DATA,
	Zone250=>:Zone250DATA,Zone251=>:Zone251DATA,Zone252=>:Zone252DATA,Zone253=>:Zone253DATA,Zone254=>:Zone254DATA,Zone255=>:Zone255DATA,Zone256=>:Zone256DATA,Zone257=>:Zone257DATA,Zone258=>:Zone258DATA,Zone259=>:Zone259DATA,Zone260=>:Zone260DATA,Zone261=>:Zone261DATA,Zone262=>:Zone262DATA,Zone263=>:Zone263DATA,Zone264=>:Zone264DATA,Zone265=>:Zone265DATA,Zone266=>:Zone266DATA,Zone267=>:Zone267DATA,Zone268=>:Zone268DATA,Zone269=>:Zone269DATA,Zone270=>:Zone270DATA,Zone271=>:Zone271DATA,Zone272=>:Zone272DATA,Zone273=>:Zone273DATA,Zone274=>:Zone274DATA,Zone275=>:Zone275DATA,Zone276=>:Zone276DATA,Zone277=>:Zone277DATA,Zone278=>:Zone278DATA,Zone279=>:Zone279DATA,Zone280=>:Zone280DATA,Zone281=>:Zone281DATA,Zone282=>:Zone282DATA,Zone283=>:Zone283DATA,Zone284=>:Zone284DATA,Zone285=>:Zone285DATA,Zone286=>:Zone286DATA,Zone287=>:Zone287DATA,Zone288=>:Zone288DATA,Zone289=>:Zone289DATA,Zone290=>:Zone290DATA,Zone291=>:Zone291DATA,Zone292=>:Zone292DATA,Zone293=>:Zone293DATA,Zone294=>:Zone294DATA,Zone295=>:Zone295DATA,Zone296=>:Zone296DATA,Zone297=>:Zone297DATA,Zone298=>:Zone298DATA,Zone299=>:Zone299DATA,
	Zone300=>:Zone300DATA,Zone301=>:Zone301DATA,Zone302=>:Zone302DATA,Zone303=>:Zone303DATA,Zone304=>:Zone304DATA,Zone305=>:Zone305DATA,Zone306=>:Zone306DATA,Zone307=>:Zone307DATA,Zone308=>:Zone308DATA,Zone309=>:Zone309DATA,Zone310=>:Zone310DATA,Zone311=>:Zone311DATA,Zone312=>:Zone312DATA,Zone313=>:Zone313DATA,Zone314=>:Zone314DATA,Zone315=>:Zone315DATA,Zone316=>:Zone316DATA,Zone317=>:Zone317DATA,Zone318=>:Zone318DATA,Zone319=>:Zone319DATA,Zone320=>:Zone320DATA,Zone321=>:Zone321DATA,Zone322=>:Zone322DATA,Zone323=>:Zone323DATA,Zone324=>:Zone324DATA,Zone325=>:Zone325DATA,Zone326=>:Zone326DATA,Zone327=>:Zone327DATA,Zone328=>:Zone328DATA,Zone329=>:Zone329DATA,Zone330=>:Zone330DATA,Zone331=>:Zone331DATA,Zone332=>:Zone332DATA,Zone333=>:Zone333DATA,Zone334=>:Zone334DATA,Zone335=>:Zone335DATA,Zone336=>:Zone336DATA,Zone337=>:Zone337DATA,Zone338=>:Zone338DATA,Zone339=>:Zone339DATA,Zone340=>:Zone340DATA,Zone341=>:Zone341DATA,Zone342=>:Zone342DATA,Zone343=>:Zone343DATA,Zone344=>:Zone344DATA,Zone345=>:Zone345DATA,Zone346=>:Zone346DATA,Zone347=>:Zone347DATA,Zone348=>:Zone348DATA,Zone349=>:Zone349DATA,
	Zone350=>:Zone350DATA,Zone351=>:Zone351DATA,Zone352=>:Zone352DATA,Zone353=>:Zone353DATA,Zone354=>:Zone354DATA,Zone355=>:Zone355DATA,Zone356=>:Zone356DATA,Zone357=>:Zone357DATA,Zone358=>:Zone358DATA,Zone359=>:Zone359DATA,Zone360=>:Zone360DATA,Zone361=>:Zone361DATA,Zone362=>:Zone362DATA,Zone363=>:Zone363DATA,Zone364=>:Zone364DATA,Zone365=>:Zone365DATA,Zone366=>:Zone366DATA,Zone367=>:Zone367DATA,Zone368=>:Zone368DATA,Zone369=>:Zone369DATA,Zone370=>:Zone370DATA,Zone371=>:Zone371DATA,Zone372=>:Zone372DATA,Zone373=>:Zone373DATA,Zone374=>:Zone374DATA,Zone375=>:Zone375DATA,Zone376=>:Zone376DATA,Zone377=>:Zone377DATA,Zone378=>:Zone378DATA,Zone379=>:Zone379DATA,Zone380=>:Zone380DATA,Zone381=>:Zone381DATA,Zone382=>:Zone382DATA,Zone383=>:Zone383DATA,Zone384=>:Zone384DATA,Zone385=>:Zone385DATA,Zone386=>:Zone386DATA,Zone387=>:Zone387DATA,Zone388=>:Zone388DATA,Zone389=>:Zone389DATA,Zone390=>:Zone390DATA,Zone391=>:Zone391DATA,Zone392=>:Zone392DATA,Zone393=>:Zone393DATA,Zone394=>:Zone394DATA,Zone395=>:Zone395DATA,Zone396=>:Zone396DATA,Zone397=>:Zone397DATA,Zone398=>:Zone398DATA,Zone399=>:Zone399DATA,
	Zone400=>:Zone400DATA,Zone401=>:Zone401DATA,Zone402=>:Zone402DATA,Zone403=>:Zone403DATA,Zone404=>:Zone404DATA,Zone405=>:Zone405DATA,Zone406=>:Zone406DATA,Zone407=>:Zone407DATA,Zone408=>:Zone408DATA,Zone409=>:Zone409DATA,Zone410=>:Zone410DATA,Zone411=>:Zone411DATA,Zone412=>:Zone412DATA,Zone413=>:Zone413DATA,Zone414=>:Zone414DATA,Zone415=>:Zone415DATA,Zone416=>:Zone416DATA,Zone417=>:Zone417DATA,Zone418=>:Zone418DATA]

#These functions retrieves the correct offset/abbreviation for a given time/timezone
const FILEPATH = dirname(@__FILE__)
function setoffset{T<:TimeZone}(tz::Type{T},secs,y,s)
	secs1 = secs - (1902 < y < 2038 ? _setoffset(tz,secs) : get(OFFSETS,tz,0))
    secs1 += y < 1972 ? 0 : s == 60 ? leaps1(secs1) : leaps(secs1)
    return secs - secs1
end
function _setoffset{T<:TimeZone}(tz::Type{T},secs)
	sym = get(DATAFILES,tz,:Zone382DATA)
	if !isdefined(Datetime,sym)
		open(joinpath(FILEPATH,"../deps/tzdata/"*string(tz)*"DATA")) do ff
			tzdata = deserialize(ff)
		end
		@eval global $sym = $tzdata
	else
		tzdata = eval(sym)
	end
	return int64(_findfirst(tzdata,int64(secs)))
end
function _findfirst(tzdata,secs)
	i = 1
	row = 1
	@inbounds begin
	while true
		if tzdata[i,2] > secs 
			if tzdata[i,2]+tzdata[i,3] <= secs
				row = i
				break
			else
				row = i-1
				break
			end
		end
		i += 1
	end 
	return tzdata[row,3]
	end
end
function getoffset{T<:TimeZone}(tz::Type{T},secs)
	sym = get(DATAFILES,tz,:Zone382DATA)
	if !isdefined(Datetime,sym)
		open(joinpath(FILEPATH,"../deps/tzdata/"*string(tz)*"DATA")) do ff
			tzdata = deserialize(ff)
		end
		@eval global $sym = $tzdata
	else
		tzdata = eval(sym)
	end
	(secs < tzdata[1,2] || secs > tzdata[end,2]) && return get(OFFSETS,tz,0)
	off = _findfirst1(tzdata,int64(secs),3) - leaps(secs)
	return off
end
function getoffset_secs{T<:TimeZone}(tz::Type{T},secs)
	sym = get(DATAFILES,tz,:Zone382DATA)
	if !isdefined(Datetime,sym)
		open(joinpath(FILEPATH,"../deps/tzdata/"*string(tz)*"DATA")) do ff
			tzdata = deserialize(ff)
		end
		@eval global $sym = $tzdata
	else
		tzdata = eval(sym)
	end
	(secs < tzdata[1,2] || secs > tzdata[end,2]) && return get(OFFSETS,tz,0)
	off = _findfirst1(tzdata,int64(secs),3) - leaps1(secs)
	return off
end
function _findfirst1(tzdata,secs,col)
	i = 1
	while true
		@inbounds (tzdata[i,2] > secs && break)
		i += 1
	end 
	return tzdata[i-1,col]
end
function getabr{T<:TimeZone}(tz::Type{T},secs,y)
	return 1902 < y < 2038 ? _getabr(tz,secs) : get(ABBREVIATIONS,tz,"UTC")
end
function _getabr{T<:TimeZone}(tz::Type{T},secs)
	tzdata = eval(get(DATAFILES,tz,:Zone382DATA))
	return _findfirst1(tzdata,int64(secs),1)
end

#typealiases for most common timezone abbreviations
#Used most common/populated zone where multiple timezones used same abbreviation
typealias ACDT Zone42; export ACDT
typealias ACST Zone42; export ACST
typealias ADT Zone59; export ADT
typealias AEDT Zone37; export AEDT
typealias AEST Zone37; export AEST
typealias AFT Zone3; export AFT
typealias AKDT Zone394; export AKDT
typealias AKST Zone394; export AKST
typealias AMST Zone71; export AMST
typealias AMT Zone71; export AMT
typealias ART Zone19; export ART
typealias AST Zone59; export AST
typealias AWDT Zone44; export AWDT
typealias AWST Zone44; export AWST
typealias AZOST Zone301; export AZOST
typealias AZT Zone48; export AZT
typealias BOT Zone61; export BOT
typealias BRT Zone70; export BRT
typealias BTT Zone80; export BTT
typealias CAT Zone342; export CAT
typealias CCT Zone112; export CCT
typealias CDT Zone382; export CDT
typealias CEDT Zone252; export CEDT
typealias CEST Zone252; export CEST
typealias CET Zone252; export CET
typealias CHADT Zone283; export CHADT
typealias CHAST Zone283; export CHAST
typealias CHOT Zone246; export CHOT
typealias CHUT Zone156; export CHUT
typealias CIT Zone190; export CIT
typealias CKT Zone119; export CKT
typealias CLST Zone120; export CLST
typealias CLT Zone120; export CLT
typealias COST Zone128; export COST
typealias COT Zone128; export COT
typealias CST Zone382; export CST
typealias CT Zone123; export CT
typealias CVT Zone131; export CVT
typealias CWST Zone45; export CWST
typealias CXT Zone133; export CXT
typealias DAVT Zone14; export DAVT
typealias DDUT Zone17; export DDUT
typealias EASST Zone121; export EASST
typealias EAST Zone121; export EAST
typealias EAT Zone340; export EAT
typealias ECT Zone143; export ECT
typealias EDT Zone372; export EDT
typealias EEDT Zone359; export EEDT
typealias EEST Zone359; export EEST
typealias EET Zone359; export EET
typealias EGST Zone171; export EGST
typealias EGT Zone171; export EGT
typealias EIT Zone191; export EIT
typealias EST Zone372; export EST
typealias FET Zone308; export FET
typealias FJT Zone154; export FJT
typealias FKST Zone155; export FKST
typealias FKT Zone155; export FKT
typealias FNT Zone63; export FNT
typealias GALT Zone144; export GALT
typealias GAMT Zone289; export GAMT
typealias GET Zone164; export GET
typealias GFT Zone165; export GFT
typealias GILT Zone208; export GILT
typealias GMT Zone0; export GMT
typealias GST Zone178; export GST
typealias GYT Zone182; export GYT
typealias HKT Zone183; export HKT
typealias HOVT Zone245; export HOVT
typealias HST Zone401; export HST
typealias ICT Zone410; export ICT
typealias IDT Zone193; export IDT
typealias IOT Zone196; export IOT
typealias IRDT Zone198; export IRDT
typealias IRKT Zone317; export IRKT
typealias IRST Zone198; export IRST
typealias IST Zone192; export IST
typealias JST Zone204; export JST
typealias KGT Zone206; export KGT
typealias KOST Zone158; export KOST
typealias KRAT Zone316; export KRAT
typealias KST Zone214; export KST
typealias LINT Zone210; export LINT
typealias MAGT Zone323; export MAGT
typealias MART Zone288; export MART
typealias MAWT Zone13; export MAWT
typealias MDT Zone389; export MDT
typealias MHT Zone240; export MHT
typealias MIST Zone34; export MIST
typealias MSK Zone309; export MSK
typealias MST Zone389; export MST
typealias MUT Zone253; export MUT
typealias MVT Zone254; export MVT
typealias MYT Zone268; export MYT
typealias NCT Zone272; export NCT
typealias NDT Zone84; export NDT
typealias NFT Zone274; export NFT
typealias NST Zone84; export NST
typealias NUT Zone281; export NUT
typealias NZDT Zone282; export NZDT
typealias NZST Zone282; export NZST
typealias OMST Zone313; export OMST
typealias ORAT Zone221; export ORAT
typealias PDT Zone109; export PDT
typealias PET Zone286; export PET
typealias PETT Zone324; export PETT
typealias PGT Zone290; export PGT
typealias PHOT Zone209; export PHOT
typealias PHT Zone291; export PHT
typealias PKT Zone292; export PKT
typealias PMDT Zone294; export PMDT
typealias PMST Zone294; export PMST
typealias PONT Zone157; export PONT
typealias PST Zone109; export PST
typealias RET Zone305; export RET
typealias ROTT Zone11; export ROTT
typealias SAKT Zone321; export SAKT
typealias SAMT Zone311; export SAMT
typealias SAST Zone416; export SAST
typealias SBT Zone328; export SBT
typealias SGT Zone332; export SGT
typealias SST Zone332; export SST
typealias SYOT Zone18; export SYOT
typealias TAHT Zone287; export TAHT
typealias THA Zone352; export THA
typealias TFT Zone350; export TFT
typealias TJT Zone353; export TJT
typealias TKT Zone354; export TKT
typealias TLT Zone355; export TLT
typealias TMT Zone356; export TMT
typealias TOT Zone358; export TOT
typealias TVT Zone361; export TVT
typealias UCT Zone0; export UCT
typealias ULAT Zone244; export ULAT
typealias UTC Zone0; export UTC
typealias UYST Zone402; export UYST
typealias UYT Zone402; export UYT
typealias UZT Zone403; export UZT
typealias VET Zone407; export VET
typealias VLAT Zone320; export VLAT
typealias VOLT Zone310; export VOLT
typealias VOST Zone16; export VOST
typealias VUT Zone411; export VUT
typealias WAKT Zone371; export WAKT
typealias WAST Zone271; export WAST
typealias WAT Zone271; export WAT
typealias WEDT Zone299; export WEDT
typealias WEST Zone299; export WEST
typealias WET Zone299; export WET
typealias YAKT Zone318; export YAKT
typealias YEKT Zone312; export YEKT

#Script to generate ZoneXDATA matrices
# cd("C:/Users/karbarcca/Google Drive/Dropbox/Dropbox/GitHub/DateTime.jl/src/tzdata")
# tzall = readdlm("timezone.csv",',')
# tzall[:,1] = map(int,tzall[:,1])
# tzall[:,3] = map(x->(int64(x)*1000)+62135683200000,tzall[:,3])
# tzall[:,4] = map(x->int64(x)*1000,tzall[:,4])
# counter = 1
# for i = 1:418
# 	counterstart = counter
# 	if i == 418
# 		counter = endof(tzall[:,1]) + 1
# 	else
# 		while tzall[counter,1] == i
# 			counter += 1
# 		end
# 	end
# 	zonedata = tzall[counterstart:counter-1,2:4]
# 	open("Zone" * string(i) * "DATA","w") do f
# 		serialize(f,zonedata)
# 	end
# end
