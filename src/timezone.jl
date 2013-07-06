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

#Zone id retrieval function
timezone(x::String) = get(TIMEZONES,x,Zone0)

#These functions retrieves the correct offset/abbreviation for a given time/timezone
#Should this be a macro? My aim was to do this at parse/compilation time
#and hopefully make it faster for subsequent calls to the same timezone
function utcoffset(tz,secs)
	tz == Zone0 && return 0
	tzdata = TIMEZONEDATA[TIMEZONEDATA[:,1].==tz,:]
	ind = findfirst(x::Int64->x>=int64(secs),tzdata[:,3]) - 1
	return tzdata[ind,4]
end
function abbreviation(tz,secs)
	tz == Zone0 && return "UTC"
	tzdata = TIMEZONEDATA[TIMEZONEDATA[:,1].==tz,:]
	ind = findfirst(x::Int64->x>=int64(secs),tzdata[:,3]) - 1
	return tzdata[ind,2]
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

const UNIXEPOCH = 62135596860 #Rata Die seconds since 1970-01-01T00:00:00 UTC

#Script to transform timezone.csv => Julia array
let
	global TIMEZONEDATA
	#cd("C:/Users/karbarcca/Google Drive/Dropbox/Dropbox/GitHub/DateTime.jl/src")
	local tzdata = readdlm(Base.dirname(Base.source_path()) * "/timezone.csv",',')
	const TIMEZONEDATA = hcat(map(x->eval(symbol("Zone" * string(int64(x)))),tzdata[:,1]),
		tzdata[:,2],map(x->int64(x)+UNIXEPOCH,tzdata[:,3]),
		map(int,tzdata[:,4]))
end