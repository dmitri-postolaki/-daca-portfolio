Nädala 1 kokkuvõte: UrbanStyle andmemaastiku analüüs

Käesolev dokument võtab kokku projekti esimese nädala tegevused, mille fookuses oli SQL-i baasteadmiste rakendamine UrbanStyle andmestiku uurimisel. Analüüsi eesmärk oli kaardistada andmete seisukord müügi, klientide, toodete ja müügikanalite lõikes.

Meeskond ja rollijaotus

Analüüsi teostas meeskond järgmises koosseisus:

* Liis Kolga (Roll A): Müügianalüüs
* Dmitri Postolaki (Roll B): Kliendiandmete analüüs
* Paul Vossotski (Roll C): Tooteandmete analüüs
* Robi Tikas (Roll D): Müügikanalite analüüs ja NotebookLM
* Germo Matt: Puudus esimesel nädalal

Rollipõhise analüüsi tulemused

Müük (Sales)

Müügiandmete analüüs keskendus tehingute mahule ja väärtustele. Tuvastati kriitilised kohad andmete kvaliteedis, mis vajavad edasist täpsustamist.

* Müügikirjete koguarv: 15 234
* Suurim tehing: 2170,40 €
* Väikseim tehing: -1405,32 €
* Puuduvad kliendi ID-d: 1487 kirjet
* Järeldus: Andmeid on piisavalt, kuid negatiivsed summad ja puuduvad seosed klientidega nõuavad kontrolli.

Kliendid (Customers)

Kliendiandmete analüüs keskendus andmebaasi täielikkusele ja unikaalsusele.

* Kliente kokku: 3150
* Puuduvad eesnimed: 0
* Puuduvad e-posti aadressid: 380
* Unikaalsed e-posti aadressid: 2640
* Järeldus: Kliendiandmed on üldiselt kvaliteetsed, kuid esineb dubleerimist e-posti aadresside tasandil.

Tooted (Products)

Tooteandmete analüüs keskendus sortimendi ja hinnastuse ülevaatele.

* Tegevused: Kontrolliti toodete koguarvu, analüüsiti kategooriaid ja hinnavahemikke.
* Järeldus: Andmestik on korrektne ja võimaldab teostada põhjalikku kategooriapõhist müügianalüüsi.

Müügikanalid (Sales Channels)

Analüüsiti UrbanStyle'i kahekanalilist müügimudelit (veebipood ja füüsilised kauplused).

* Kaupluste asukohad: Tallinn, Tartu, Pärnu.
* Makseviisid: Pangakaart, sularaha ja järelmaks.
* Tehniline märkus: Veebimüügi kirjete puhul on store_location väärtus alati NULL. See on ootuspärane, kuna e-müük ei ole seotud konkreetse füüsilise asukohaga.

Peamised andmekvaliteedi tähelepanekud

Analüüsi käigus koondati olulisemad andmetega seotud leiud järgmisse tabelisse:

Valdkond	Tähelepanek	Hulk/Väärtus
Müük	Müügikirjeid kokku	15 234
Müük	Negatiivsed müügisummad	Tuvastatud
Müük	Puuduv kliendi ID	1487 kirjet
Kliendid	Puuduvad e-posti aadressid	380
Kliendid	Korduvad e-posti aadressid	510 (3150 vs 2640 unikaalset)
Kanalid	Veebimüügi asukohaandmed	NULL (ootuspärane)

Soovitused andmete parendamiseks

Põhjalikuma ärianalüüsi tegemiseks on soovitatav astuda järgmised sammud:

1. Andmelünkade täitmine: Uurida, miks 1487 müügikirjel puudub customer_id ning püüda täita puuduvad 380 e-posti aadressi kliendibaasis.
2. Negatiivsete summade valideerimine: Teha kindlaks, kas negatiivsed total_price väärtused tähistavad tagastusi, tühistamisi või sisestusvigu.
3. Duplikaatide kontroll: Selgitada välja, kas korduvad e-posti aadressid viitavad samadele isikutele või on tegemist andmekvaliteedi probleemiga.
4. Müügikanalite kontroll: Veenduda, et füüsiliste kaupluste müügid sisaldaksid alati korrektset asukohainfot.
5. Dokumentatsiooni täiendamine: Lisada selgitused veergude ja ärireeglite kohta, et tagada andmete ühene mõistmine kõigile analüütikutele.

Kokkuvõte ja õpiväljundid

Esimese nädala jooksul omandas meeskond praktilisi oskusi SQL-i kasutamisel andmete uurimiseks (EDA - Exploratory Data Analysis). Analüüsiti UrbanStyle'i müügi-, kliendi-, toote- ja müügikanalite andmeid. Tulemusena on meeskonnal selge ülevaade andmestiku struktuurist ja kvaliteedist. Tuvastatud andmevead ja nende parandamine loob usaldusväärse aluse järgmiste nädalate süvitsi minevatele analüüsidele ja äriliste otsuste tegemisele.

