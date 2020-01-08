package sk.doreto.signlanguage.database;


import android.os.AsyncTask;
import android.util.Log;

import androidx.annotation.NonNull;

import java.util.LinkedList;
import java.util.List;

import sk.doreto.signlanguage.R;


public class DatabaseInitializer {

    public static void populateAsync(@NonNull final AppDatabase db) {
        PopulateDbAsync task = new PopulateDbAsync(db);
        task.execute();
    }

    public static void populateSync(@NonNull final AppDatabase db) {

        populateWithLectionData(db);
        populateWithWordData(db);
        populateWithSentenceData(db);
        joinWordWithSentence(db);
    }


    private static void populateWithWordData(AppDatabase db) {


        Word wordArray [] = {
                //Lesson 1 - Prvy kontakt I
                new Word(0, "Ahoj", 0, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(1, "Ja", 0,"lection1_ano", "lection1_ano1", true),
                new Word(2, "Ty", 0,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(3, "On/Ona", 0, "lection1_onona", "lection1_onona1", true),
                new Word(4, "Áno", 0, "lection1_ano", "lection1_ano1", true),
                new Word(5, "Nie", 0, "lection1_nie", "lection1_nie1", true),
                new Word(6, "Nepočujúci", 0, "lection1_nepocujuci", "lection1_nepocujuci1", true),
                new Word(7, "Počujúci", 0, "lection1_pocujuci", "lection1_pocujuci1", true),
                new Word(8, "Rozumieť", 0, "lection1_rozumiet", "lection1_rozumiet1", true),
                new Word(9, "Nerozumieť", 0,  "lection1_nerozumiet", "lection1_nerozumiet1", true),
                new Word(10, "Nedoslýchaví", 0,  "lection1_nedoslychavy", "lection1_nedoslychavy1", true),
                new Word(11, "Muž", 0, "lection1_muz", "lection1_muz1", true),
                new Word(12, "Žena", 0,  "lection1_zena", "lection1_zena1", true),
                new Word(13, "Chlapec", 0,  "lection1_chlapec", "lection1_chlapec1", true),
                new Word(14, "Dievča", 0,  "lection1_dievca", "lection1_dievca1", true),

                //Lesson 2 - Prvy kontakt II
                new Word(15, "Meno", 1, "lection2_meno", "lection2_meno1", true),
                new Word(16, "Moje", 1,"lection2_moje", "lection2_moje1", true),
                new Word(17, "Tvoje", 1,"lection2_tvoje", "lection2_tvoje1", true),
                new Word(18, "Jeho/Jej", 1, "lection2_jehojej", "lection2_jehojej1", true),
                new Word(19, "Kto", 1, "lection2_kto", "lection2_kto1", true),
                new Word(20, "My", 1, "lection2_my", "lection2_my1", true),
                new Word(21, "Vy", 1, "lection2_vy", "lection2_vy1", true),
                new Word(22, "Rovnako", 1, "lection2_rovnako", "lection2_rovnako1", true),
                new Word(23, "Čo", 1,  "lection2_co", "lection2_co1", true),
                new Word(24, "Ako", 1,  "lection2_ako", "lection2_ako1", true),
                new Word(25, "Alebo", 1, "lection2_alebo", "lection2_alebo1", true),
                new Word(26, "Dobre", 1,  "lection2_dobre", "lection2_dobre1", true),
                new Word(27, "Zle", 1,  "lection2_zle", "lection2_zle1", true),
                new Word(28, "Prosiť", 1,  "lection2_prosit", "lection2_prosit1", true),
                new Word(29, "Prepáč", 1,  "lection2_prepac", "lection2_prepac1", true),

                //Lesson 3 - Prvy kontakt III
                new Word(30, "Ráno", 2, "lection3_rano", "lection3_rano1", true),
                new Word(31, "Obed", 2,"lection3_obed", "lection3_obed1", true),
                new Word(32, "Poobede", 2,"lection3_poobede", "lection3_poobede1", true),
                new Word(33, "Večer", 2, "lection3_vecer", "lection3_vecer1", true),
                new Word(34, "Noc", 2, "lection3_noc", "lection3_noc1", true),
                new Word(35, "Deň", 2, "lection3_den", "lection3_den1", true),
                new Word(36, "Osoba", 2, "lection3_osoba", "lection3_osoba1", true),
                new Word(37, "Kamarát/ka", 2, "lection3_kamarat", "lection3_kamarat1", true),
                new Word(38, "Kolega/Kolegyňa", 2,  "lection3_kolega", "lection3_kolega1", true),
                new Word(39, "Ďakujem", 2,  "lection3_dakujem", "lection3_dakujem1", true),
                new Word(40, "Pozdraviť", 2, "lection3_pozdravit", "lection3_pozdravit1", true),
                new Word(41, "Poznať", 2,  "lection3_poznat", "lection3_poznat1", true),
                new Word(42, "Tešiť sa", 2,  "lection3_tesitsa", "lection3_tesitsa1", true),
                new Word(43, "Stretnúť", 2,  "lection3_stretnut", "lection3_stretnut1", true),
                new Word(44, "Opakovať", 2,  "lection3_opakovat", "lection3_opakovat1", true),

                //Lesson 4 - Rodina I
                new Word(45, "Mama", 3, "lection4_mama", "lection4_mama1", true),
                new Word(46, "Otec", 3,"lection4_otec", "lection4_otec1", true),
                new Word(47, "Dcéra", 3,"lection4_dcera", "lection4_dcera1", true),
                new Word(48, "Syn", 3, "lection4_syn", "lection4_syn1", true),
                new Word(49, "Rodina", 3, "lection4_rodina", "lection4_rodina1", true),
                new Word(50, "Brat", 3, "lection4_brat", "lection4_brat1", true),
                new Word(51, "Sestra", 3, "lection4_sestra", "lection4_sestra1", true),
                new Word(52, "Deti", 3, "lection4_deti", "lection4_deti1", true),
                new Word(53, "Mám", 3,  "lection4_mam", "lection4_mam1", true),
                new Word(54, "Nemám", 3,  "lection4_nemam", "lection4_nemam1", true),
                new Word(55, "Babka", 3, "lection4_babka", "lection4_babka1", true),
                new Word(56, "Dedko", 3,  "lection4_dedko", "lection4_dedko1", true),
                new Word(57, "Dieťa", 3,  "lection4_dieta", "lection4_dieta1", true),
                new Word(58, "Ženatý/Vydatá", 3,  "lection4_zenaty", "lection4_zenaty1", true),
                new Word(59, "Slobodný/á", 3,  "lection4_slobodny", "lection4_slobodny1", true),

                //Lesson 5 - Rodina II
                new Word(60, "Vnuk", 4, "lection5_vnuk", "lection5_vnuk1", true),
                new Word(61, "Vnučka", 4,"lection5_vnucka", "lection5_vnucka1", true),
                new Word(62, "Manžel/ka", 4,"lection5_manzel", "lection5_manzel1", true),
                new Word(63, "Rozvedený/á", 4, "lection5_rozvedeny", "lection5_rozvedeny1", true),
                new Word(64, "Manželia", 4, "lection5_manzelia", "lection5_manzelia1", true),
                new Word(65, "Frajer/ka", 4, "lection5_frajer", "lection5_frajer1", true),
                new Word(66, "Priateľ/ka", 4, "lection5_priatel", "lection5_priatel1", true),
                new Word(67, "Druh/Družka\"", 4, "lection5_druh", "lection5_druh1", true),
                new Word(68, "Teta", 4,  "lection5_teta", "lection5_teta1", true),
                new Word(69, "Ujo", 4,  "lection5_ujo", "lection5_ujo1", true),
                new Word(70, "Žiť", 4, "lection5_zit", "lection5_zit1", true),
                new Word(71, "Spolu", 4,  "lection5_spolu", "lection5_spolu1", true),
                new Word(72, "Rozvod/Rozchod", 4,  "lection5_rozvod", "lection5_rozvod1", true),
                new Word(73, "Rande", 4,  "lection5_rande", "lection5_rande1", true),
                new Word(74, "Láska", 4,  "lection5_laska", "lection5_laska1", true),

                //Lesson 6 - Čísla I.
                new Word(75, "0 - 5", 5, "lection1_ahoj", "lection1_ahoj1", false),
                new Word(76, "6 - 10", 5,"lection1_ano", "lection1_ano1", false),
                new Word(77, "11 - 15", 5,"lection1_chlapec", "lection1_chlapec1", false),
                new Word(78, "16 - 20", 5, "test", "testSide", false),
                new Word(79, "21 - 25", 5, "ahoj", "ahojSide", false),
                new Word(80, "26 - 30", 5, "test", "testSide", false),
                new Word(81, "31 - 35", 5, "ahoj", "ahojSide", false),
                new Word(82, "46 - 50", 5, "test", "testSide", false),
                new Word(83, "51 - 55", 5,  "ahoj", "ahojSide", false),
                new Word(84, "66 - 70", 5,  "test", "testSide", false),
                new Word(85, "81 - 85", 5, "test", "testSide", false),
                new Word(86, "96 - 99", 5,  "test", "testSide", false),
                new Word(87, "Číslo", 5,  "test", "testSide", true),
                new Word(88, "+/-/*/:/=", 5,  "test", "testSide", false),
                new Word(89, "Rokov", 5,  "test", "testSide", true),

                //Lesson 7 - Čísla II.
                new Word(90, "100 - 500", 6, "lection1_ahoj", "lection1_ahoj1", false),
                new Word(91, "600 - 900", 6,"lection1_ano", "lection1_ano1", false),
                new Word(92, "1000 - 5000", 6,"lection1_chlapec", "lection1_chlapec1", false),
                new Word(93, "6000 - 10000", 6, "test", "testSide", false),
                new Word(94, "200000 - 50000", 6, "ahoj", "ahojSide", false),
                new Word(95, "100 000", 6, "test", "testSide", false),
                new Word(96, "250 000", 6, "ahoj", "ahojSide", false),
                new Word(97, "700 000", 6, "test", "testSide", false),
                new Word(98, "1 000 000", 6,  "ahoj", "ahojSide", false),
                new Word(99, "10 000 000", 6,  "test", "testSide", false),
                new Word(100, "Starý", 6, "test", "testSide", true),
                new Word(101, "Mladý", 6,  "test", "testSide", true),
                new Word(102, "Koľko", 6,  "test", "testSide", true),
                new Word(103, "Správne", 6,  "test", "testSide", true),
                new Word(104, "Nesprávne", 6,  "test", "testSide", true),

                //Lesson 8 - Materiály a farby I.
                new Word(105, "Farba", 7, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(106, "Biela", 7,"lection1_ano", "lection1_ano1", true),
                new Word(107, "Žltá", 7,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(108, "Ružová", 7, "test", "testSide", true),
                new Word(109, "Oranžová", 7, "ahoj", "ahojSide", true),
                new Word(110, "Červená", 7, "test", "testSide", true),
                new Word(111, "Fialová", 7, "ahoj", "ahojSide", true),
                new Word(112, "Svetlá", 7, "test", "testSide", true),
                new Word(113, "Tmavá", 7,  "ahoj", "ahojSide", true),
                new Word(114, "Farebná", 7,  "test", "testSide", true),
                new Word(115, "Milovať", 7, "test", "testSide", true),
                new Word(116, "Neznášať", 7,  "test", "testSide", true),
                new Word(117, "Pekná", 7,  "test", "testSide", true),
                new Word(118, "Škaredá", 7,  "test", "testSide", true),
                new Word(119, "Moderná", 7,  "test", "testSide", true),

                //Lesson 9 - Materiály a farby II.
                new Word(120, "Modrá", 8, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(121, "Hnedá", 8,"lection1_ano", "lection1_ano1", true),
                new Word(122, "Zelená", 8,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(123, "Sivá", 8, "test", "testSide", true),
                new Word(124, "Čierna", 8, "ahoj", "ahojSide", true),
                new Word(125, "Materiál", 8, "test", "testSide", true),
                new Word(126, "Papier", 8, "ahoj", "ahojSide", true),
                new Word(127, "Drevo", 8, "test", "testSide", true),
                new Word(128, "Železo/Kov", 8,  "ahoj", "ahojSide", true),
                new Word(129, "Sklo", 8,  "test", "testSide", true),
                new Word(130, "Keramika", 8, "test", "testSide", true),
                new Word(131, "Látka", 8,  "test", "testSide", true),
                new Word(132, "Koža", 8,  "test", "testSide", true),
                new Word(133, "Tvrdá", 8,  "test", "testSide", true),
                new Word(134, "Mäkká", 8,  "test", "testSide", true),

                //Lesson 10 - Bývanie I.
                new Word(135, "Byt", 9, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(136, "Dom", 9,"lection1_ano", "lection1_ano1", true),
                new Word(137, "Panelák", 9,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(138, "Doma", 9, "test", "testSide", true),
                new Word(139, "Domov", 9, "ahoj", "ahojSide", true),
                new Word(140, "Sused/ka", 9, "test", "testSide", true),
                new Word(141, "Izba", 9, "ahoj", "ahojSide", true),
                new Word(142, "Poschodie", 9, "test", "testSide", true),
                new Word(143, "Podnájom", 9,  "ahoj", "ahojSide", true),
                new Word(144, "Prenájom", 9,  "test", "testSide", true),
                new Word(145, "Nový", 9, "test", "testSide", true),
                new Word(146, "Vlastný", 9,  "test", "testSide", true),
                new Word(147, "Bývať", 9,  "test", "testSide", true),
                new Word(148, "Kde", 9,  "test", "testSide", true),
                new Word(149, "Kam", 9,  "test", "testSide", true),

                //Lesson 11 - Bývanie II.
                new Word(150, "Ubytovanie", 10, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(151, "Internát", 10,"lection1_ano", "lection1_ano1", true),
                new Word(152, "Chata", 10,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(153, "Môže", 10, "test", "testSide", true),
                new Word(154, "Nemôže", 10, "ahoj", "ahojSide", true),
                new Word(155, "Pozemok", 10, "test", "testSide", true),
                new Word(156, "Prísť", 10, "ahoj", "ahojSide", true),
                new Word(157, "Odísť", 10, "test", "testSide", true),
                new Word(158, "Sťahovať", 10,  "ahoj", "ahojSide", true),
                new Word(159, "Navštíviť", 10,  "test", "testSide", true),
                new Word(160, "Malý", 10, "test", "testSide", true),
                new Word(161, "Veľký", 10,  "test", "testSide", true),
                new Word(162, "Preč", 10,  "test", "testSide", true),
                new Word(163, "Chodiť", 10,  "test", "testSide", true),
                new Word(164, "Isť do", 10,  "test", "testSide", true),

                //Lesson 12 - Inštitúcie I.
                new Word(165, "Nemocnica", 11, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(166, "Škola", 11,"lection1_ano", "lection1_ano1", true),
                new Word(167, "Pošta", 11,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(168, "Polícia", 11, "test", "testSide", true),
                new Word(169, "Televízia", 11, "ahoj", "ahojSide", true),
                new Word(170, "Kostol", 11, "test", "testSide", true),
                new Word(171, "Úrad", 11, "ahoj", "ahojSide", true),
                new Word(172, "Reštaurácia", 11, "test", "testSide", true),
                new Word(173, "Banka", 11,  "ahoj", "ahojSide", true),
                new Word(174, "Obchod", 11,  "test", "testSide", true),
                new Word(175, "Vedľa", 11, "test", "testSide", true),
                new Word(176, "Blízko", 11,  "test", "testSide", true),
                new Word(177, "Ďaleko", 11,  "test", "testSide", true),
                new Word(178, "Otvorené", 11,  "test", "testSide", true),
                new Word(179, "Zatvorené", 11,  "test", "testSide", true),

                //Lesson 13 - Inštitúcie II.
                new Word(180, "Kino", 12, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(181, "Múzeum", 12,"lection1_ano", "lection1_ano1", true),
                new Word(182, "Hrad", 12,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(183, "Zámok", 12, "test", "testSide", true),
                new Word(184, "Divadlo", 12, "ahoj", "ahojSide", true),
                new Word(185, "Centrum", 12, "test", "testSide", true),
                new Word(186, "Námestie", 12, "ahoj", "ahojSide", true),
                new Word(187, "Ulica", 12, "test", "testSide", true),
                new Word(188, "Park", 12,  "ahoj", "ahojSide", true),
                new Word(189, "Hotel", 12,  "test", "testSide", true),
                new Word(190, "Služba", 12, "test", "testSide", true),
                new Word(191, "Firma", 12,  "test", "testSide", true),
                new Word(192, "Oproti", 12,  "test", "testSide", true),
                new Word(193, "Všetko", 12,  "test", "testSide", true),
                new Word(194, "Prechádzať", 12,  "test", "testSide", true),

                //Lesson 14 - Mestá I.
                new Word(195, "Bratislava", 13, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(196, "Blava", 13,"lection1_ano", "lection1_ano1", true),
                new Word(197, "Košice", 13,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(198, "Nitra", 13, "test", "testSide", true),
                new Word(199, "Žilina", 13, "ahoj", "ahojSide", true),
                new Word(200, "Banská Bystrica", 13, "test", "testSide", true),
                new Word(201, "Lučenec", 13, "ahoj", "ahojSide", true),
                new Word(202, "Poprad", 13, "test", "testSide", true),
                new Word(203, "Liptovský Mikuláš", 13,  "ahoj", "ahojSide", true),
                new Word(204, "Prešov", 13,  "test", "testSide", true),
                new Word(205, "Trnava", 13, "test", "testSide", true),
                new Word(206, "Mesto", 13,  "test", "testSide", true),
                new Word(207, "Dedina", 13,  "test", "testSide", true),
                new Word(208, "Okres", 13,  "test", "testSide", true),
                new Word(209, "Pekné", 13,  "test", "testSide", true),
                new Word(210, "Škaredé", 13,  "test", "testSide", true),

                //Lesson 15 - Mestá II.
                new Word(211, "Zvolen", 14, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(212, "Trenčín", 14,"lection1_ano", "lection1_ano1", true),
                new Word(213, "Prievidza", 14,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(214, "Martin", 14, "test", "testSide", true),
                new Word(215, "Púchov", 14, "ahoj", "ahojSide", true),
                new Word(216, "Vysoké Tatry", 14, "test", "testSide", true),
                new Word(217, "Ružomberok", 14, "ahoj", "ahojSide", true),
                new Word(218, "Žiar nad Hronom", 14, "test", "testSide", true),
                new Word(219, "Dunajská Streda", 14,  "ahoj", "ahojSide", true),
                new Word(220, "Piešťany", 14,  "test", "testSide", true),
                new Word(221, "Chcieť", 14, "test", "testSide", true),
                new Word(222, "Nechcieť", 14,  "test", "testSide", true),
                new Word(223, "Pochádzať", 14,  "test", "testSide", true),
                new Word(224, "Cestovať", 14,  "test", "testSide", true),
                new Word(225, "Odkiaľ", 14,  "test", "testSide", true),

                //Lesson 16 - Doprava I.
                new Word(226, "Auto", 15, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(227, "Motorka", 15,"lection1_ano", "lection1_ano1", true),
                new Word(228, "Autobus", 15,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(229, "Vlak", 15, "test", "testSide", true),
                new Word(230, "Trolejbus", 15, "ahoj", "ahojSide", true),
                new Word(231, "Električka", 15, "test", "testSide", true),
                new Word(232, "Lietadlo", 15, "ahoj", "ahojSide", true),
                new Word(233, "Bicykel", 15, "test", "testSide", true),
                new Word(234, "Loď", 15,  "ahoj", "ahojSide", true),
                new Word(235, "Doprava", 15,  "test", "testSide", true),
                new Word(236, "Jazdiť", 15, "test", "testSide", true),
                new Word(237, "Pomaly", 15,  "test", "testSide", true),
                new Word(238, "Rýchlo", 15,  "test", "testSide", true),
                new Word(239, "Drahe", 15,  "test", "testSide", true),
                new Word(240, "Lacne", 15,  "test", "testSide", true),

                //Lesson 17 - Doprava II.
                new Word(241, "Metro", 16, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(242, "Most", 16,"lection1_ano", "lection1_ano1", true),
                new Word(243, "Diaľnica", 16,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(244, "Cesta", 16, "test", "testSide", true),
                new Word(245, "Parkovisko", 16, "test", "testSide", true),
                new Word(246, "Taxi", 16, "ahoj", "ahojSide", true),
                new Word(247, "Semafor", 16, "test", "testSide", true),
                new Word(248, "Nehoda", 16,  "ahoj", "ahojSide", true),
                new Word(249, "Turbulencia", 16,  "test", "testSide", true),
                new Word(250, "Rieka", 16, "test", "testSide", true),
                new Word(251, "Šofér", 16,  "test", "testSide", true),
                new Word(252, "Pri", 16,  "test", "testSide", true),
                new Word(253, "Problém", 16,  "test", "testSide", true),
                new Word(254, "Pokuta", 16,  "test", "testSide", true),

                //Lesson 18 - Čas I.
                new Word(255, "Čas", 17, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(256, "Sekudna", 17,"lection1_ano", "lection1_ano1", true),
                new Word(257, "Minúta", 17,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(258, "Hodina", 17, "test", "testSide", true),
                new Word(259, "Hodiny", 17, "test", "testSide", true),
                new Word(260, "1h - 5h", 17, "ahoj", "ahojSide", false),
                new Word(261, "6h - 10h", 17, "test", "testSide", false),
                new Word(262, "11h - 12h", 17,  "ahoj", "ahojSide", false),
                new Word(263, "o 1h - o 6h", 17,  "test", "testSide", false),
                new Word(264, "o 7h - o 12h", 17, "test", "testSide", false),
                new Word(265, "O koľkej", 17,  "test", "testSide", true),
                new Word(266, "Kedy", 17,  "test", "testSide", true),
                new Word(267, "Meškať", 17,  "test", "testSide", true),
                new Word(268, "Čakať", 17,  "test", "testSide", true),
                new Word(269, "Vstávať", 17,  "test", "testSide", true),

                //Lesson 19 - Čas II.
                new Word(270, "Práca", 18, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(271, "Dovolenka", 18,"lection1_ano", "lection1_ano1", true),
                new Word(272, "Voľno", 18,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(273, "Teraz", 18, "test", "testSide", true),
                new Word(274, "Každý", 18, "test", "testSide", true),
                new Word(275, "Pravidelne", 18, "ahoj", "ahojSide", true),
                new Word(276, "Nepravidelne", 18, "test", "testSide", true),
                new Word(277, "Bude", 18,  "ahoj", "ahojSide", true),
                new Word(278, "Bolo", 18,  "test", "testSide", true),
                new Word(279, "Jesť", 18, "test", "testSide", true),
                new Word(280, "Odpočívať", 18,  "test", "testSide", true),
                new Word(281, "Pred", 18,  "test", "testSide", true),
                new Word(282, "Po", 18,  "test", "testSide", true),
                new Word(283, "Asi", 18,  "test", "testSide", true),
                new Word(284, "Až", 18,  "test", "testSide", true),

                //Lesson 20 - Kalendár I.
                new Word(285, "Pondelok", 19, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(286, "Utorok", 19,"lection1_ano", "lection1_ano1", true),
                new Word(287, "Streda", 19,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(288, "Štvrtok", 19, "test", "testSide", true),
                new Word(289, "Piatok", 19, "test", "testSide", true),
                new Word(290, "Sobota", 19, "ahoj", "ahojSide", true),
                new Word(291, "Nedeľa", 19, "test", "testSide", true),
                new Word(292, "Týždeň", 19,  "ahoj", "ahojSide", true),
                new Word(293, "Sviatok", 19,  "test", "testSide", true),
                new Word(294, "Dnes", 19, "test", "testSide", true),
                new Word(295, "Včera", 19,  "test", "testSide", true),
                new Word(296, "Zajtra", 19,  "test", "testSide", true),
                new Word(297, "Kalendár", 19,  "test", "testSide", true),
                new Word(298, "Prázdniny", 19,  "test", "testSide", true),
                new Word(299, "Víkend", 19,  "test", "testSide", true),

                //Lesson 21 - Kalendár II.
                new Word(300, "Január", 20,  "test", "testSide", true),
                new Word(301, "Február", 20, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(302, "Marec", 20,"lection1_ano", "lection1_ano1", true),
                new Word(303, "Apríl", 20,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(304, "Máj", 20, "test", "testSide", true),
                new Word(305, "Jún", 20, "test", "testSide", true),
                new Word(306, "Júl", 20, "ahoj", "ahojSide", true),
                new Word(307, "August", 20, "test", "testSide", true),
                new Word(308, "September", 20,  "ahoj", "ahojSide", true),
                new Word(309, "Október", 20,  "test", "testSide", true),
                new Word(310, "November", 20, "test", "testSide", true),
                new Word(311, "December", 20,  "test", "testSide", true),
                new Word(312, "Mesiac", 20,  "test", "testSide", true),
                new Word(313, "Rok", 20,  "test", "testSide", true),
                new Word(314, "Dátum", 20,  "test", "testSide", true),

                //Lesson 22 - Zvieratá I.
                new Word(315, "Pes", 21,  "test", "testSide", true),
                new Word(316, "Mačka", 21, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(317, "Sliepka", 21,"lection1_ano", "lection1_ano1", true),
                new Word(318, "Krava", 21,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(319, "Koza", 21, "test", "testSide", true),
                new Word(320, "Prasa", 21, "test", "testSide", true),
                new Word(321, "Kôn", 21, "ahoj", "ahojSide", true),
                new Word(322, "Zajac", 21, "test", "testSide", true),
                new Word(323, "Ovca", 21,  "ahoj", "ahojSide", true),
                new Word(324, "Hus", 21,  "test", "testSide", true),
                new Word(325, "Farma", 21, "test", "testSide", true),
                new Word(326, "Dvor", 21,  "test", "testSide", true),
                new Word(327, "Kŕmiť", 21,  "test", "testSide", true),
                new Word(328, "Strážiť", 21,  "test", "testSide", true),
                new Word(329, "Chovať", 21,  "test", "testSide", true),

                //Lesson 23 - Zvieratá II.
                new Word(330, "Medveď", 22,  "test", "testSide", true),
                new Word(331, "Vlk", 22, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(332, "Jeleň", 22,"lection1_ano", "lection1_ano1", true),
                new Word(333, "Srna", 22,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(334, "Myš", 22, "test", "testSide", true),
                new Word(335, "Motýľ", 22, "test", "testSide", true),
                new Word(336, "Líška", 22, "ahoj", "ahojSide", true),
                new Word(337, "Žaba", 22, "test", "testSide", true),
                new Word(338, "Veverička", 22,  "ahoj", "ahojSide", true),
                new Word(339, "Včela", 22,  "test", "testSide", true),
                new Word(340, "Les", 22, "test", "testSide", true),
                new Word(341, "Zviera", 22,  "test", "testSide", true),
                new Word(342, "Strom", 22,  "test", "testSide", true),
                new Word(343, "Báť sa", 22,  "test", "testSide", true),
                new Word(344, "Dôvod", 22,  "test", "testSide", true),

                //Lesson 24 - Zvieratá III.
                new Word(345, "Opica", 23,  "test", "testSide", true),
                new Word(346, "Gorila", 23, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(347, "Lev", 23,"lection1_ano", "lection1_ano1", true),
                new Word(348, "Tiger", 23,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(349, "Slon", 23, "test", "testSide", true),
                new Word(350, "Had", 23, "test", "testSide", true),
                new Word(351, "Krokodil", 23, "ahoj", "ahojSide", true),
                new Word(352, "Žirafa", 23, "test", "testSide", true),
                new Word(353, "Korytnačka", 23,  "ahoj", "ahojSide", true),
                new Word(354, "Ťava", 23,  "test", "testSide", true),
                new Word(355, "ZOO", 23, "test", "testSide", true),
                new Word(356, "Nebezpečný", 23,  "test", "testSide", true),
                new Word(357, "Jedovatý", 23,  "test", "testSide", true),
                new Word(358, "Hrať", 23,  "test", "testSide", true),
                new Word(359, "Niektoré", 23,  "test", "testSide", true),

                //Lesson 25 - Ovocie
                new Word(360, "Jablko", 24,  "test", "testSide", true),
                new Word(361, "Pomaranč", 24, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(362, "Slivka", 24,"lection1_ano", "lection1_ano1", true),
                new Word(363, "Citron", 24,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(364, "Banán", 24, "test", "testSide", true),
                new Word(365, "Čerešne", 24, "test", "testSide", true),
                new Word(366, "Hrozno", 24, "ahoj", "ahojSide", true),
                new Word(367, "Jahoda", 24, "test", "testSide", true),
                new Word(368, "Hruška", 24,  "ahoj", "ahojSide", true),
                new Word(369, "Broskyňa", 24,  "test", "testSide", true),
                new Word(370, "Sladké", 24, "test", "testSide", true),
                new Word(371, "Kyslé", 24,  "test", "testSide", true),
                new Word(372, "Chutné", 24,  "test", "testSide", true),
                new Word(373, "Čerstvé", 24,  "test", "testSide", true),
                new Word(374, "Ovocie", 24,  "test", "testSide", true),

                //Lesson 26 - Zelenina
                new Word(375, "Paradjaka", 25,  "test", "testSide", true),
                new Word(376, "Cibuľa", 25, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(377, "Paprika", 25,"lection1_ano", "lection1_ano1", true),
                new Word(378, "Mrkva", 25,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(379, "Kapusta", 25, "test", "testSide", true),
                new Word(380, "Kukurica", 25, "test", "testSide", true),
                new Word(381, "Uhorka", 25, "ahoj", "ahojSide", true),
                new Word(382, "Zemiaky", 25, "test", "testSide", true),
                new Word(383, "Cesnak", 25,  "ahoj", "ahojSide", true),
                new Word(384, "Hrach", 25,  "test", "testSide", true),
                new Word(385, "Ošúpať", 25, "test", "testSide", true),
                new Word(386, "Zelenina", 25,  "test", "testSide", true),
                new Word(387, "Zdravá", 25,  "test", "testSide", true),
                new Word(388, "Tržnica", 25,  "test", "testSide", true),
                new Word(389, "Kúpiť", 25,  "test", "testSide", true),

                //Lesson 27 - Ročné obdobie I.
                new Word(390, "Jar", 26,  "test", "testSide", true),
                new Word(391, "Leto", 26, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(392, "Jeseň", 26,"lection1_ano", "lection1_ano1", true),
                new Word(393, "Zima", 26,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(394, "Teplo", 26, "test", "testSide", true),
                new Word(395, "Príroda", 26, "test", "testSide", true),
                new Word(396, "Záhrada", 26, "ahoj", "ahojSide", true),
                new Word(397, "Kvet", 26, "test", "testSide", true),
                new Word(398, "Tráva", 26,  "ahoj", "ahojSide", true),
                new Word(399, "Počasie", 26,  "test", "testSide", true),
                new Word(400, "Krásne", 26, "test", "testSide", true),
                new Word(401, "Sadiť", 26,  "test", "testSide", true),
                new Word(402, "Rásť", 26,  "test", "testSide", true),
                new Word(403, "Kopať", 26,  "test", "testSide", true),
                new Word(404, "Oberať", 26,  "test", "testSide", true),

                //Lesson 28 - Ročné obdobie II.
                new Word(405, "More", 27,  "test", "testSide", true),
                new Word(406, "Hora", 27, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(407, "Horúco", 27,"lection1_ano", "lection1_ano1", true),
                new Word(408, "Jazero", 27,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(409, "List", 27, "test", "testSide", true),
                new Word(410, "Dážď", 27, "test", "testSide", true),
                new Word(411, "Vianoce", 27, "ahoj", "ahojSide", true),
                new Word(412, "Oblečenie", 27, "test", "testSide", true),
                new Word(413, "Sneh", 27,  "ahoj", "ahojSide", true),
                new Word(414, "Vietor", 27,  "test", "testSide", true),
                new Word(415, "Silný", 27, "test", "testSide", true),
                new Word(416, "Slabý", 27,  "test", "testSide", true),
                new Word(417, "Padať", 27,  "test", "testSide", true),
                new Word(418, "Tenké", 27,  "test", "testSide", true),
                new Word(419, "Hrubé", 27,  "test", "testSide", true),

                //Lesson 29 - ABECEDA
                new Word(420, "A, Á, Ä", 28,  "test", "testSide", false),
                new Word(421, "B", 28, "lection1_ahoj", "lection1_ahoj1", false),
                new Word(422, "C, Č", 28,"lection1_ano", "lection1_ano1", false),
                new Word(423, "D, Ď", 28,"lection1_chlapec", "lection1_chlapec1", false),
                new Word(424, "E, É", 28, "test", "testSide", false),
                new Word(425, "F", 28, "test", "testSide", false),
                new Word(426, "G", 28, "ahoj", "ahojSide", false),
                new Word(427, "H, CH", 28, "test", "testSide", false),
                new Word(428, "I, Í", 28,  "ahoj", "ahojSide", false),
                new Word(429, "J", 28,  "test", "testSide", false),
                new Word(430, "K", 28, "test", "testSide", false),
                new Word(431, "L, Ĺ, Ľ", 28,  "test", "testSide", false),
                new Word(432, "M", 28,  "test", "testSide", false),
                new Word(433, "N, Ň", 28,  "test", "testSide", false),
                new Word(434, "O, Ó, Ô", 28,  "test", "testSide", false),
                new Word(435, "P", 28,  "test", "testSide", false),
                new Word(436, "Q", 28,  "test", "testSide", false),
                new Word(437, "R, Ŕ", 28,  "test", "testSide", false),
                new Word(438, "S, Š", 28,  "test", "testSide", false),
                new Word(439, "T, Ť", 28,  "test", "testSide", false),
                new Word(440, "U, Ú", 28,  "test", "testSide", false),
                new Word(441, "V, W", 28,  "test", "testSide", false),
                new Word(442, "X", 28,  "test", "testSide", false),
                new Word(443, "Y, Ý", 28,  "test", "testSide", false),
                new Word(444, "Z, Ž", 28,  "test", "testSide", false)
        };

        for (Word word : wordArray)
            db.wordDao().insertAll(word);
        
    }

    private static void populateWithLectionData(AppDatabase db) {

        Lection lectionArray[] = {
                new Lection(0,"Prvý kontakt I.",  "first_contact_1"),
                new Lection(1,"Prvý kontakt II.", "first_contact_2"),
                new Lection(2,"Prvý kontakt III.", "first_contact_3"),
                new Lection(3,"Rodina I.", "family_1"),
                new Lection(4,"Rodina II.", "family_2"),
                new Lection(5,"Čísla I.", "numbers_1"),
                new Lection(6,"Čísla II.", "numbers_2"),
                new Lection(7,"Farby I.", "colors_1"),
                new Lection(8,"Farby II.", "colors_2"),
                new Lection(9,"Bývanie I.", "live_1"),
                new Lection(10,"Bývanie II.", "live_2"),
                new Lection(11,"Inštitúcie I.", "institution_1"),
                new Lection(12,"Inštitúcie II.", "institution_2"),
                new Lection(13,"Mestá I.", "city_1"),
                new Lection(14,"Mestá II.", "city_2"),
                new Lection(15,"Doprava I.", "transport_1"),
                new Lection(16,"Doprava II.", "transport_2"),
                new Lection(17,"Čas I.", "time_1"),
                new Lection(18,"Čas II.", "time_2"),
                new Lection(19,"Kalendár I.", "calendar_1"),
                new Lection(20,"Kalendár II.", "calendar_2"),
                new Lection(21,"Zvierata I.", "animals_1"),
                new Lection(22,"Zvierata II.", "animals_2"),
                new Lection(23,"Zvierata III.", "animals_3"),
                new Lection(24,"Ovocie", "fruits_1"),
                new Lection(25,"Zelenina", "vegetables_2"),
                new Lection(26,"Ročné obdobie I.", "season_1"),
                new Lection(27,"Ročné obdobie II.", "season_2"),
                new Lection(28,"Abeceda", "alphabet")
        };


        for (Lection lection : lectionArray)
            db.lectionDao().insertAll(lection);
    }

    private static void populateWithSentenceData(AppDatabase db) {

        Sentence sentencesArray [] = {

                //Lesson 1 - Prvy kontakt I
                new Sentence(0, "On je nepočujúci.", "lection1_0"),
                new Sentence(1, "Som chlapec.", "lection1_1"),
                new Sentence(2, "Dievča je počujúca.", "lection1_2"),
                new Sentence(3, "Rozumieš?", "lection1_3"),
                new Sentence(4, "Ona je nedoslýchavá.", "lection1_4"),
                new Sentence(5, "Ja ti nerozumiem.", "lection1_5"),

                //Lesson 2 - - Prvy kontakt II
                new Sentence(6, "Moje meno je Michal.", "lection2_6"),
                new Sentence(7, "Kto som?", "lection2_7"),
                new Sentence(8, "Ako sa máš?", "lection2_8"),
                new Sentence(9, "My sme počujúci.", "lection2_9"),
                new Sentence(10, "Žena je zlá.", "lection2_10"),
                new Sentence(11, "Prepáč, ja ti nerozumiem.", "lection2_11"),

                //Lesson 3 - Prvy kontakt III
                new Sentence(12, "Dobre ráno.", "lection3_12"),
                new Sentence(13, "Dobrý deň.", "lection3_13"),
                new Sentence(14, "Dobrý večer!", "lection3_14"),
                new Sentence(15, "Tvoja kamarátka je nepočujúca?", "lection3_15"),
                new Sentence(16, "Ona pozná nepočujúceho muža.", "lection3_16"),
                new Sentence(17, "Moja kolegyňa je nedoslýchavá.", "lection3_17"),

                //Lesson 4 - Rodina I
                new Sentence(18, "Mám počujúcu sestru.", "lection4_18"),
                new Sentence(19, "Poznám jeho rodičov.", "lection4_19"),
                new Sentence(20, "Môj brat je ženatý.", "lection4_20"),
                new Sentence(21, "On má nepočujúcu dcéru.", "lection4_21"),
                new Sentence(22, "Nemám súrodencov.", "lection4_22"),
                new Sentence(23, "Moje dieťa v noci spí.", "lection4_23"),

                //Lesson 5 - Rodina I
                new Sentence(24, "Mám priateľku.", "lection5_24"),
                new Sentence(25, "Má babka vnučku?", "lection5_25"),
                new Sentence(26, "Moja mama je rozvedená.", "lection5_26"),
                new Sentence(27, "Druh a družka majú deti.", "lection5_27"),
                new Sentence(28, "Ako sa volá tvoj druh?", "lection5_28"),
                new Sentence(29, "Manželia nemajú deti.", "lection5_29"),

                //Lesson 6 - Cisla I
                new Sentence(30, "Mám tri kamarátky.", "lection6_30"),
                new Sentence(31, "Mám štyroch bratov.", "lection6_31"),
                new Sentence(32, "Môj otec má 37 rokov.", "lection6_32"),
                new Sentence(33, "Moja kolegyňa je vydatá a má 4 deti.", "lection6_33"),
                new Sentence(34, "Manželia sú spolu už 19 rokov.", "lection6_34"),
                new Sentence(35, "Chlapec má 12 rokov.", "lection6_35"),

                //Lesson 7 - Cisla II
                new Sentence(36, "Koľko máš rokov?", ""),
                new Sentence(37, "67 – 12 = ?", ""),
                new Sentence(38, "Moja sestra má 17 rokov.", ""),
                new Sentence(39, "Starý muž má 70 rokov.", ""),
                new Sentence(40, "30 + 50 = 80. Je to správne?", ""),
                new Sentence(41, "Mladá žena má 27 rokov.", ""),

                //Lesson 8 - Meterialy a farby I
                new Sentence(42, "Oranžové, fialové a červené farby sú pekné.", ""),
                new Sentence(43, "Otec má rád tmavé farby.", ""),
                new Sentence(44, "Milujem žltú farbu a neznášam čiernu farbu.", ""),
                new Sentence(45, "Milujem svetlú červenú farbu.", ""),
                new Sentence(46, "Nemám rád hnedú a čiernu farbu.", ""),
                new Sentence(47, "Tá žena je škaredá.", ""),

                //Lesson 9 - Meterialy a farby II
                new Sentence(48, "Modrá keramika je pekná.", ""),
                new Sentence(49, "Mám rád tmavé drevo.", ""),
                new Sentence(50, "Jeho žena má rada zelenú farbu.", ""),
                new Sentence(51, "Neznášam tvrdú kožu.", ""),
                new Sentence(52, "Tmavo sivý kov je pekný a moderný.", ""),
                new Sentence(53, "Milujem moderné sklá.", ""),

                //Lection 10 - Byvanie I.
                new Sentence(54, "Mám starý dom.", ""),
                new Sentence(55, "Babka má vlastný byt.", ""),
                new Sentence(56, "On sa teší domov.", ""),
                new Sentence(57, "Poznáš jej susedku?", ""),
                new Sentence(58, "Kde bývaš?", ""),
                new Sentence(59, "Môj kolega býva v prenájme.", ""),

                //Lection 11 - Byvani II
                new Sentence(60, "Bývam na internáte.", ""),
                new Sentence(61, "Ja mám veľký byt.", ""),
                new Sentence(62, "Kam ideš?", ""),
                new Sentence(63, "Susedia v noci odišli preč.", ""),
                new Sentence(64, "Na ktorom poschodí bývaš?", ""),
                new Sentence(65, "Tvoja chata je stará alebo nová?", ""),

                //Lection 12 - Institucie I.
                new Sentence(66, "Ideme do centra, je to blízko.", ""),
                new Sentence(67, "Môj dedko býva ďaleko.", ""),
                new Sentence(68, "Nerád chodím na úrad.", ""),
                new Sentence(69, "Pošta má modro-žltú farbu.", ""),
                new Sentence(70, "Idem do školy.", ""),
                new Sentence(71, "Veľké obchody sú zatvorené.", ""),

                //Lection 13 - Institucie II.
                new Sentence(72, "Môj otec rád chodí do kina.", ""),
                new Sentence(73, "Na námestí sú reštaurácie otvorené.", ""),
                new Sentence(74, "Oproti divadlu je múzeum.", ""),
                new Sentence(75, "Vedľa múzea je hnedý zámok.", ""),
                new Sentence(76, "Rád sa prechádzam v parku.", ""),
                new Sentence(77, "Na ulici je tam starý hotel.", ""),

                //Lection 14 - Mestá I.
                new Sentence(78, "Môj brat býva v Žiline.", ""),
                new Sentence(79, "V Bratislave sú staré červeno-žlté električky.", ""),
                new Sentence(80, "Neznášam dedinu.", ""),
                new Sentence(81, "Prešov je pekné mesto.", ""),
                new Sentence(82, "Tešíš sa ísť do Popradu?", ""),
                new Sentence(83, "Na dedine sú farebné domy a biely kostol.", ""),

                //Lection 15 - Mestá II.
                new Sentence(84, "Blízko Prievidze je zámok.", ""),
                new Sentence(85, "Odkiaľ si?", ""),
                new Sentence(86, "Žijem vo Zvolene.", ""),
                new Sentence(87, "Nechcem bývať v Ružomberku.", ""),
                new Sentence(88, "Moja rodina pochádza z Košíc.", ""),
                new Sentence(89, "Druhovia spolu žijú už 13 rokov v Nitre.", ""),

                //Lection 16 - Doprava I.
                new Sentence(90, "Auto ide pomaly.", ""),
                new Sentence(91, "Plávať loďou.", ""),
                new Sentence(92, "Kto má fialové auto?", ""),
                new Sentence(93, "Žena išla rýchlo motorkou do nemocnice.", ""),
                new Sentence(94, "Môj brat má starý bicykel.", ""),
                new Sentence(95, "Rád chodím na starom aute.", ""),

                //Lection 17 - Doprava II.
                new Sentence(96, "V centre mesta taxík jazdí pomaly.", ""),
                new Sentence(97, "Nie som dobrý šofér, ale moja sestra áno.", ""),
                new Sentence(98, "V Bratislave nie je metro.", ""),
                new Sentence(99, "V centre mesta je problém s parkovaním.", ""),
                new Sentence(100, "Stretneme sa na parkovisku pri moste?", ""),
                new Sentence(101, "Včera v noci auto a autobus havarovali pri tuneli.", ""),

                //Lection 18 - Cas I.
                new Sentence(102, "9:03", ""),
                new Sentence(103, "6:25", ""),
                new Sentence(104, "14:40", ""),
                new Sentence(105, "20:30", ""),
                new Sentence(106, "Koľko je hodín?", ""),
                new Sentence(107, "Ja idem spať o 23 hod.", ""),

                //Lection 19 - Cas II.
                new Sentence(108, "Každý deň chodím do práce.", ""),
                new Sentence(109, "Chodíš pravidelne do divadla?", ""),
                new Sentence(110, "Na úrade som čakal 2 hodiny.", ""),
                new Sentence(111, "Nechce sa mi.", ""),
                new Sentence(112, "Nemám čas.", ""),
                new Sentence(113, "Za hodinu príde vlak.", ""),

                //Lection 20 - Kalendar I.
                new Sentence(114, "Včera bola nedeľa.", ""),
                new Sentence(115, "Prídem v sobotu večer.", ""),
                new Sentence(116, "Dnes je štvrtok.", ""),
                new Sentence(117, "Zajtra budem mať voľno.", ""),
                new Sentence(118, "Cez víkend budem u babky.", ""),
                new Sentence(119, "V piatok sme mali stretnutie.", ""),

                //Lection 21 - Kalendar II.
                new Sentence(120, "12.5.2018", ""),
                new Sentence(121, "6.2.1980", ""),
                new Sentence(122, "20.8.2001", ""),
                new Sentence(123, "4.4.1944", ""),
                new Sentence(124, "Dňa 1.5. je sviatok práce.", ""),
                new Sentence(125, "Rok má 12 mesiacov.", ""),

                //Lection 22 - Zvierata I.
                new Sentence(126, "Môj dedo choval ovce, kravy aj kone.", ""),
                new Sentence(127, "Prasa zje všetko.", ""),
                new Sentence(128, "Pes vie dobre strážiť.", ""),
                new Sentence(129, "Na dedine je tam veľká farma.", ""),
                new Sentence(130, "Babka mojej kamarátky má veľký dvor.", ""),
                new Sentence(131, "Chová tam sliepky, husi, zajace a kozy.", ""),
                new Sentence(132, "Dedina pri Zolene má krásny dvor. ", ""),
                new Sentence(133, "Vo dvore chovajú ovce, kozy a kone.", ""),

                //Lection 23 - Zvierata II.
                new Sentence(134, "Veverička žije na strome.", ""),
                new Sentence(135, "Moja mama sa bojí myší.", ""),
                new Sentence(136, "Medveď biely má rád zimu.", ""),
                new Sentence(137, "Moja teta doma chová motýle.", ""),
                new Sentence(138, "Na chate pri lese sme videli veľa žáb.", ""),
                new Sentence(139, "V lese žijú medvede, srnky aj líšky.", ""),

                //Lection 24 - Zvierata III.
                new Sentence(140, "Opice sa radi hrajú.", ""),
                new Sentence(141, "Lev a tiger nie sú dobrí kamaráti.", ""),
                new Sentence(142, "Bojím sa chodiť sama do lesa, lebo sú tam nebezpečné zvieratá.", ""),
                new Sentence(143, "Moja vnučka chce mať doma hada.", ""),
                new Sentence(144, "Pri Prievidzi je tam ZOO.", ""),
                new Sentence(145, "Krokodíl, lev, tiger a niektoré hady sú nebezpečné zvieratá.", ""),

                //Lection 25 - Ovocie I.
                new Sentence(146, "V Júni bývajú jahody.", ""),
                new Sentence(147, "Mamička v nedeľu upiekla čerešňový koláč.", ""),
                new Sentence(148, "Hrozno býva kyslé aj sladké.", ""),
                new Sentence(149, "Pomaranče mi viac chutia v zime.", ""),
                new Sentence(150, "Banány môžeme kúpiť za 1 € a jablká za 80 centov.", ""),
                new Sentence(151, "Moje dieťa má radšej ovocie ako zeleninu.", ""),

                //Lection 26 - Zelenina I.
                new Sentence(152, "Deti musia jesť veľa ovocia a zeleniny.", ""),
                new Sentence(153, "Pri ceste predávajú domácu zeleninu.", ""),
                new Sentence(154, "Nerád šúpem zemiaky.", ""),
                new Sentence(155, "Na trhovisku predávajú čerstvé ovocie.", ""),
                new Sentence(156, "Na trhovisku môžem ochutnať kyslú kapustu.", ""),
                new Sentence(157, "Rád jem veľa zeleniny, preto som zdravý.", ""),

                //Lection 27 - Seasson I.
                new Sentence(158, "Na jar sadíme kvety.", ""),
                new Sentence(159, "Dievčaťa majú radi krásne kvety.", ""),
                new Sentence(160, "Na jeseň sa oberá hrozno.", ""),
                new Sentence(161, "Vo dvore rastie tráva.", ""),
                new Sentence(162, "Môj priateľ miluje jeseň, lebo je krásne farebná.", ""),
                new Sentence(163, "Moji starí rodičia pestujú v záhrade kapustu a mrkvu.", ""),

                //Lection 28 - Seasson II.
                new Sentence(164, "Nerád jazdím autom, keď je vonku sneh.", ""),
                new Sentence(165, "V júli je horúco.", ""),
                new Sentence(166, "Na horách bývajú silné vetry.", ""),
                new Sentence(167, "Vianoce je krásne obdobie.", ""),
                new Sentence(168, "V zime si oblečiem hrubé oblečenie.", ""),
                new Sentence(169, "Jablká rastú na jeseň.", "")
        };


        for (Sentence sentence : sentencesArray)
            db.sentenceDao().insertAll(sentence);

    }

    private static void addSentenceToWord(List<WordSentenceJoin> join, int wordId, int [] sentenceId) {

        for (int id : sentenceId) {
            join.add(new WordSentenceJoin(wordId, id));
        }

    }

    private static void joinWordWithSentence(AppDatabase db) {

        List<WordSentenceJoin> wordSentenceJoinArray = new LinkedList();

        addSentenceToWord(wordSentenceJoinArray, 1, new int[]{5, 11}); // Ja
        addSentenceToWord(wordSentenceJoinArray, 3, new int[]{0, 4, 16}); //On/Ona
        addSentenceToWord(wordSentenceJoinArray, 6, new int[]{0, 16}); //Nepočujúci
        addSentenceToWord(wordSentenceJoinArray, 7, new int[]{2, 9}); //Počujúci
        addSentenceToWord(wordSentenceJoinArray, 8, new int[]{3}); //Rozumieť
        addSentenceToWord(wordSentenceJoinArray, 9, new int[]{5, 11}); //Nerozumieť
        addSentenceToWord(wordSentenceJoinArray, 10, new int[]{4, 17}); //Nedoslýchaví
        addSentenceToWord(wordSentenceJoinArray, 11, new int[]{16}); //Muž
        addSentenceToWord(wordSentenceJoinArray, 12, new int[]{10}); //Žena
        addSentenceToWord(wordSentenceJoinArray, 13, new int[]{1}); //Chlapec
        addSentenceToWord(wordSentenceJoinArray, 14, new int[]{2}); //Dievča
        addSentenceToWord(wordSentenceJoinArray, 15, new int[]{6}); //Meno
        addSentenceToWord(wordSentenceJoinArray, 16, new int[]{6, 17}); //Moje
        addSentenceToWord(wordSentenceJoinArray, 17, new int[]{15, 28}); //Tvoje
        addSentenceToWord(wordSentenceJoinArray, 18, new int[]{19});  //Jeho/Jej
        addSentenceToWord(wordSentenceJoinArray, 19, new int[]{7}); //Kto
        addSentenceToWord(wordSentenceJoinArray, 20, new int[]{9}); //My
        addSentenceToWord(wordSentenceJoinArray, 24, new int[]{8}); //Ako
        addSentenceToWord(wordSentenceJoinArray, 26, new int[]{12, 13, 14}); //Dobre
        addSentenceToWord(wordSentenceJoinArray, 27, new int[]{10}); //Zle
        addSentenceToWord(wordSentenceJoinArray, 29, new int[]{11}); //Prepáč
        addSentenceToWord(wordSentenceJoinArray, 30, new int[]{12}); //Ráno
        addSentenceToWord(wordSentenceJoinArray, 33, new int[]{14, 115}); //Večer
        addSentenceToWord(wordSentenceJoinArray, 34, new int[]{63}); //Noc
        addSentenceToWord(wordSentenceJoinArray, 35, new int[]{13, 108}); //Deň
        addSentenceToWord(wordSentenceJoinArray, 37, new int[]{15}); //Kamarát/ka
        addSentenceToWord(wordSentenceJoinArray, 38, new int[]{17, 59}); //Kolega/Kolegyňa
        addSentenceToWord(wordSentenceJoinArray, 41, new int[]{16, 19}); //Poznať
        addSentenceToWord(wordSentenceJoinArray, 42, new int[]{82}); //Tešiť sa
        addSentenceToWord(wordSentenceJoinArray, 45, new int[]{26}); //Mama
        addSentenceToWord(wordSentenceJoinArray, 46, new int[]{32, 72}); //Otec
        addSentenceToWord(wordSentenceJoinArray, 47, new int[]{21}); //Dcéra
        addSentenceToWord(wordSentenceJoinArray, 49, new int[]{88}); //Rodina
        addSentenceToWord(wordSentenceJoinArray, 50, new int[]{20, 31}); //Brat
        addSentenceToWord(wordSentenceJoinArray, 51, new int[]{18}); //Sestra
        addSentenceToWord(wordSentenceJoinArray, 52, new int[]{23, 27, 29}); //Deti
        addSentenceToWord(wordSentenceJoinArray, 53, new int[]{18, 54}); //Mám
        addSentenceToWord(wordSentenceJoinArray, 54, new int[]{22, 112}); //Nemám
        addSentenceToWord(wordSentenceJoinArray, 55, new int[]{25}); //Babka
        addSentenceToWord(wordSentenceJoinArray, 56, new int[]{67}); //Dedko
        addSentenceToWord(wordSentenceJoinArray, 58, new int[]{20, 33}); //Ženatý/Vydatá
        addSentenceToWord(wordSentenceJoinArray, 61, new int[]{25}); //Vnučka
        addSentenceToWord(wordSentenceJoinArray, 63, new int[]{26}); //Rozvedený/á
        addSentenceToWord(wordSentenceJoinArray, 64, new int[]{29, 34}); //Manželia
        addSentenceToWord(wordSentenceJoinArray, 66, new int[]{24}); //Priateľ/ka
        addSentenceToWord(wordSentenceJoinArray, 67, new int[]{27, 28}); //Druh/Družka
        addSentenceToWord(wordSentenceJoinArray, 68, new int[]{137}); //Teta
        addSentenceToWord(wordSentenceJoinArray, 70, new int[]{86}); //Žiť
        addSentenceToWord(wordSentenceJoinArray, 71, new int[]{34}); //Spolu
        addSentenceToWord(wordSentenceJoinArray, 75, new int[]{30, 31, 33}); //0 - 5
        addSentenceToWord(wordSentenceJoinArray, 77, new int[]{35}); //11 - 15
        addSentenceToWord(wordSentenceJoinArray, 78, new int[]{34}); //16 - 20
        addSentenceToWord(wordSentenceJoinArray, 81, new int[]{32}); //31 - 35
        addSentenceToWord(wordSentenceJoinArray, 88, new int[]{37, 40}); //+/-/*/:/=
        addSentenceToWord(wordSentenceJoinArray, 89, new int[]{38, 39}); //Rokov
        addSentenceToWord(wordSentenceJoinArray, 100, new int[]{39, 54}); //Starý
        addSentenceToWord(wordSentenceJoinArray, 101, new int[]{41}); //Mladý
        addSentenceToWord(wordSentenceJoinArray, 102, new int[]{36}); //Koľko
        addSentenceToWord(wordSentenceJoinArray, 103, new int[]{40}); //Správne
        addSentenceToWord(wordSentenceJoinArray, 105, new int[]{42, 43, 69}); //Farba
        addSentenceToWord(wordSentenceJoinArray, 106, new int[]{83}); //Biela
        addSentenceToWord(wordSentenceJoinArray, 107, new int[]{44, 69}); //Žltá
        addSentenceToWord(wordSentenceJoinArray, 109, new int[]{42}); //Oranžová
        addSentenceToWord(wordSentenceJoinArray, 110, new int[]{42, 45}); //Červená
        addSentenceToWord(wordSentenceJoinArray, 111, new int[]{42, 92}); //Fialová
        addSentenceToWord(wordSentenceJoinArray, 112, new int[]{45}); //Svetlá
        addSentenceToWord(wordSentenceJoinArray, 113, new int[]{43, 49, 52}); //Tmavá
        addSentenceToWord(wordSentenceJoinArray, 115, new int[]{44, 45}); //Milovať
        addSentenceToWord(wordSentenceJoinArray, 116, new int[]{44, 80}); //Neznášať
        addSentenceToWord(wordSentenceJoinArray, 117, new int[]{42}); //Pekná
        addSentenceToWord(wordSentenceJoinArray, 118, new int[]{47}); //Škaredá
        addSentenceToWord(wordSentenceJoinArray, 119, new int[]{52, 53}); //Moderná
        addSentenceToWord(wordSentenceJoinArray, 120, new int[]{48, 69}); //Modrá
        addSentenceToWord(wordSentenceJoinArray, 121, new int[]{46}); //Hnedá
        addSentenceToWord(wordSentenceJoinArray, 122, new int[]{50}); //Zelená
        addSentenceToWord(wordSentenceJoinArray, 123, new int[]{52}); //Sivá
        addSentenceToWord(wordSentenceJoinArray, 124, new int[]{44, 46}); //Čierna
        addSentenceToWord(wordSentenceJoinArray, 127, new int[]{49}); //Drevo
        addSentenceToWord(wordSentenceJoinArray, 128, new int[]{52}); //Železo/Kov
        addSentenceToWord(wordSentenceJoinArray, 129, new int[]{53}); //Sklo
        addSentenceToWord(wordSentenceJoinArray, 130, new int[]{48}); //Keramika
        addSentenceToWord(wordSentenceJoinArray, 132, new int[]{51}); //Koža
        addSentenceToWord(wordSentenceJoinArray, 133, new int[]{51}); //Tvrdá
        addSentenceToWord(wordSentenceJoinArray, 135, new int[]{55, 61}); //Byt
        addSentenceToWord(wordSentenceJoinArray, 136, new int[]{54, 83}); //Dom
        addSentenceToWord(wordSentenceJoinArray, 138, new int[]{137}); //Doma
        addSentenceToWord(wordSentenceJoinArray, 139, new int[]{56}); //Domov
        addSentenceToWord(wordSentenceJoinArray, 140, new int[]{57, 63}); //Sused/ka
        addSentenceToWord(wordSentenceJoinArray, 142, new int[]{64}); //Poschodie
        addSentenceToWord(wordSentenceJoinArray, 144, new int[]{59}); //Prenájom
        addSentenceToWord(wordSentenceJoinArray, 145, new int[]{65}); //Nový
        addSentenceToWord(wordSentenceJoinArray, 146, new int[]{53}); //Vlastný
        addSentenceToWord(wordSentenceJoinArray, 148, new int[]{58});  //Kde
        addSentenceToWord(wordSentenceJoinArray, 149, new int[]{62}); //Kam
        addSentenceToWord(wordSentenceJoinArray, 151, new int[]{60}); //Internát
        addSentenceToWord(wordSentenceJoinArray, 152, new int[]{65}); //Chata
        addSentenceToWord(wordSentenceJoinArray, 156, new int[]{113}); //Prísť
        addSentenceToWord(wordSentenceJoinArray, 157, new int[]{63}); //Odísť
        addSentenceToWord(wordSentenceJoinArray, 161, new int[]{61}); //Veľký
        addSentenceToWord(wordSentenceJoinArray, 162, new int[]{63}); //Preč
        addSentenceToWord(wordSentenceJoinArray, 163, new int[]{68, 95, 109}); //Chodiť
        addSentenceToWord(wordSentenceJoinArray, 164, new int[]{62, 70}); //Isť do
        addSentenceToWord(wordSentenceJoinArray, 165, new int[]{93}); //Nemocnica
        addSentenceToWord(wordSentenceJoinArray, 166, new int[]{70}); //Škola
        addSentenceToWord(wordSentenceJoinArray, 167, new int[]{69}); //Pošta
        addSentenceToWord(wordSentenceJoinArray, 170, new int[]{83}); //Kostol
        addSentenceToWord(wordSentenceJoinArray, 171, new int[]{68, 110}); //Úrad
        addSentenceToWord(wordSentenceJoinArray, 172, new int[]{73}); //Reštaurácia
        addSentenceToWord(wordSentenceJoinArray, 174, new int[]{71}); //Obchod
        addSentenceToWord(wordSentenceJoinArray, 175, new int[]{75}); //Vedľa
        addSentenceToWord(wordSentenceJoinArray, 176, new int[]{66, 84}); //Blízko
        addSentenceToWord(wordSentenceJoinArray, 177, new int[]{67}); //Ďaleko
        addSentenceToWord(wordSentenceJoinArray, 178, new int[]{73}); //Otvorené
        addSentenceToWord(wordSentenceJoinArray, 179, new int[]{71}); //Zatvorené
        addSentenceToWord(wordSentenceJoinArray, 180, new int[]{72}); //Kino
        addSentenceToWord(wordSentenceJoinArray, 181, new int[]{75}); //Múzeum
        addSentenceToWord(wordSentenceJoinArray, 183, new int[]{75, 82}); //Zámok
        addSentenceToWord(wordSentenceJoinArray, 184, new int[]{74, 109}); //Divadlo
        addSentenceToWord(wordSentenceJoinArray, 185, new int[]{66, 96}); //Centrum
        addSentenceToWord(wordSentenceJoinArray, 186, new int[]{73}); //Námestie
        addSentenceToWord(wordSentenceJoinArray, 187, new int[]{77}); //Ulica
        addSentenceToWord(wordSentenceJoinArray, 188, new int[]{76}); //Park
        addSentenceToWord(wordSentenceJoinArray, 189, new int[]{77}); //Hotel
        addSentenceToWord(wordSentenceJoinArray, 192, new int[]{74}); //Oproti
        addSentenceToWord(wordSentenceJoinArray, 193, new int[]{127}); //Všetko
        addSentenceToWord(wordSentenceJoinArray, 194, new int[]{76}); //Prechádzať
        addSentenceToWord(wordSentenceJoinArray, 195, new int[]{79}); //Bratislava
        addSentenceToWord(wordSentenceJoinArray, 196, new int[]{79}); //Blava
        addSentenceToWord(wordSentenceJoinArray, 197, new int[]{88}); //Košice
        addSentenceToWord(wordSentenceJoinArray, 198, new int[]{89}); //Nitra
        addSentenceToWord(wordSentenceJoinArray, 199, new int[]{78}); //Žilina
        addSentenceToWord(wordSentenceJoinArray, 202, new int[]{82}); //Poprad
        addSentenceToWord(wordSentenceJoinArray, 204, new int[]{81}); //Prešov
        addSentenceToWord(wordSentenceJoinArray, 206, new int[]{96, 99}); //Mesto
        addSentenceToWord(wordSentenceJoinArray, 207, new int[]{80, 83}); //Dedina
        addSentenceToWord(wordSentenceJoinArray, 209, new int[]{81}); //Pekné
        addSentenceToWord(wordSentenceJoinArray, 211, new int[]{86}); //Zvolen
        addSentenceToWord(wordSentenceJoinArray, 213, new int[]{84}); //Prievidza
        addSentenceToWord(wordSentenceJoinArray, 217, new int[]{87}); //Ružomberok
        addSentenceToWord(wordSentenceJoinArray, 222, new int[]{87}); //Nechcieť
        addSentenceToWord(wordSentenceJoinArray, 223, new int[]{88}); //Pochádzať
        addSentenceToWord(wordSentenceJoinArray, 225, new int[]{85}); //Odkiaľ
        addSentenceToWord(wordSentenceJoinArray, 226, new int[]{90, 92, 95}); //Auto
        addSentenceToWord(wordSentenceJoinArray, 227, new int[]{93}); //Motorka
        addSentenceToWord(wordSentenceJoinArray, 228, new int[]{101}); //Autobus
        addSentenceToWord(wordSentenceJoinArray, 229, new int[]{113}); //Vlak
        addSentenceToWord(wordSentenceJoinArray, 231, new int[]{79}); //Električka
        addSentenceToWord(wordSentenceJoinArray, 233, new int[]{94}); //Bicykel
        addSentenceToWord(wordSentenceJoinArray, 234, new int[]{91}); //Loď
        addSentenceToWord(wordSentenceJoinArray, 236, new int[]{164}); //Jazdiť
        addSentenceToWord(wordSentenceJoinArray, 237, new int[]{90, 96}); //Pomaly
        addSentenceToWord(wordSentenceJoinArray, 238, new int[]{93}); //Rýchlo
        addSentenceToWord(wordSentenceJoinArray, 241, new int[]{98}); //Metro
        addSentenceToWord(wordSentenceJoinArray, 242, new int[]{100}); //Most
        addSentenceToWord(wordSentenceJoinArray, 244, new int[]{153}); //Cesta
        addSentenceToWord(wordSentenceJoinArray, 245, new int[]{100}); //Parkovisko
        addSentenceToWord(wordSentenceJoinArray, 246, new int[]{96}); //Taxi
        addSentenceToWord(wordSentenceJoinArray, 251, new int[]{97}); //Šofér
        addSentenceToWord(wordSentenceJoinArray, 253, new int[]{99}); //Problém
        addSentenceToWord(wordSentenceJoinArray, 255, new int[]{105, 107, 112}); //Čas
        addSentenceToWord(wordSentenceJoinArray, 258, new int[]{106, 110}); //Hodina
        addSentenceToWord(wordSentenceJoinArray, 261, new int[]{102}); //6h - 10h
        addSentenceToWord(wordSentenceJoinArray, 262, new int[]{104}); //11h - 12h
        addSentenceToWord(wordSentenceJoinArray, 263, new int[]{103}); //o 1h - o 6h
        addSentenceToWord(wordSentenceJoinArray, 265, new int[]{106}); //O koľkej
        addSentenceToWord(wordSentenceJoinArray, 268, new int[]{110}); //Čakať
        addSentenceToWord(wordSentenceJoinArray, 270, new int[]{108}); //Práca
        addSentenceToWord(wordSentenceJoinArray, 272, new int[]{117}); //Voľno
        addSentenceToWord(wordSentenceJoinArray, 275, new int[]{109}); //Pravidelne
        addSentenceToWord(wordSentenceJoinArray, 278, new int[]{114}); //Bolo
        addSentenceToWord(wordSentenceJoinArray, 288, new int[]{116}); //Štvrtok
        addSentenceToWord(wordSentenceJoinArray, 289, new int[]{119}); //Piatok
        addSentenceToWord(wordSentenceJoinArray, 290, new int[]{115}); //Sobota
        addSentenceToWord(wordSentenceJoinArray, 291, new int[]{114}); //Nedeľa
        addSentenceToWord(wordSentenceJoinArray, 293, new int[]{124}); //Sviatok
        addSentenceToWord(wordSentenceJoinArray, 294, new int[]{116}); //Dnes
        addSentenceToWord(wordSentenceJoinArray, 295, new int[]{114}); //Včera
        addSentenceToWord(wordSentenceJoinArray, 296, new int[]{117}); //Zajtra
        addSentenceToWord(wordSentenceJoinArray, 299, new int[]{118}); //Víkend
        addSentenceToWord(wordSentenceJoinArray, 301, new int[]{121}); //Február
        addSentenceToWord(wordSentenceJoinArray, 303, new int[]{123}); //Apríl
        addSentenceToWord(wordSentenceJoinArray, 304, new int[]{120, 124}); //Máj
        addSentenceToWord(wordSentenceJoinArray, 305, new int[]{146}); //Jún
        addSentenceToWord(wordSentenceJoinArray, 306, new int[]{165}); //Júl
        addSentenceToWord(wordSentenceJoinArray, 307, new int[]{122}); //August
        addSentenceToWord(wordSentenceJoinArray, 312, new int[]{125}); //Mesiac
        addSentenceToWord(wordSentenceJoinArray, 313, new int[]{125}); //Rok
        addSentenceToWord(wordSentenceJoinArray, 314, new int[]{120, 121}); //Dátum
        addSentenceToWord(wordSentenceJoinArray, 315, new int[]{128}); //Pes
        addSentenceToWord(wordSentenceJoinArray, 317, new int[]{131}); //Sliepka
        addSentenceToWord(wordSentenceJoinArray, 318, new int[]{126}); //Krava
        addSentenceToWord(wordSentenceJoinArray, 319, new int[]{131, 133}); //Koza
        addSentenceToWord(wordSentenceJoinArray, 320, new int[]{127}); //Prasa
        addSentenceToWord(wordSentenceJoinArray, 321, new int[]{126, 133}); //Kôn
        addSentenceToWord(wordSentenceJoinArray, 322, new int[]{131}); //Zajac
        addSentenceToWord(wordSentenceJoinArray, 323, new int[]{126, 133}); //Ovca
        addSentenceToWord(wordSentenceJoinArray, 325, new int[]{129}); //Farma
        addSentenceToWord(wordSentenceJoinArray, 326, new int[]{130, 132}); //Dvor
        addSentenceToWord(wordSentenceJoinArray, 328, new int[]{128}); //Strážiť
        addSentenceToWord(wordSentenceJoinArray, 329, new int[]{126}); //Chovať
        addSentenceToWord(wordSentenceJoinArray, 330, new int[]{136, 139}); //Medveď
        addSentenceToWord(wordSentenceJoinArray, 333, new int[]{139}); //Srna
        addSentenceToWord(wordSentenceJoinArray, 334, new int[]{135}); //Myš
        addSentenceToWord(wordSentenceJoinArray, 335, new int[]{137}); //Motýľ
        addSentenceToWord(wordSentenceJoinArray, 336, new int[]{139}); //Líška
        addSentenceToWord(wordSentenceJoinArray, 337, new int[]{128}); //Žaba
        addSentenceToWord(wordSentenceJoinArray, 338, new int[]{134}); //Veverička
        addSentenceToWord(wordSentenceJoinArray, 340, new int[]{138}); //Les
        addSentenceToWord(wordSentenceJoinArray, 341, new int[]{142}); //Zviera
        addSentenceToWord(wordSentenceJoinArray, 342, new int[]{134}); //Strom
        addSentenceToWord(wordSentenceJoinArray, 343, new int[]{135, 142}); //Báť sa
        addSentenceToWord(wordSentenceJoinArray, 345, new int[]{140}); //Opica
        addSentenceToWord(wordSentenceJoinArray, 347, new int[]{141, 145}); //Lev
        addSentenceToWord(wordSentenceJoinArray, 348, new int[]{141, 145}); //Tiger
        addSentenceToWord(wordSentenceJoinArray, 350, new int[]{143}); //Had
        addSentenceToWord(wordSentenceJoinArray, 351, new int[]{145}); //Krokodil
        addSentenceToWord(wordSentenceJoinArray, 355, new int[]{144}); //ZOO
        addSentenceToWord(wordSentenceJoinArray, 356, new int[]{142, 145}); //Nebezpečný
        addSentenceToWord(wordSentenceJoinArray, 358, new int[]{140}); //Hrať
        addSentenceToWord(wordSentenceJoinArray, 360, new int[]{150, 169}); //Jablko
        addSentenceToWord(wordSentenceJoinArray, 361, new int[]{149}); //Pomaranč
        addSentenceToWord(wordSentenceJoinArray, 364, new int[]{150}); //Banán
        addSentenceToWord(wordSentenceJoinArray, 365, new int[]{147}); //Čerešne
        addSentenceToWord(wordSentenceJoinArray, 366, new int[]{148, 160}); //Hrozno
        addSentenceToWord(wordSentenceJoinArray, 367, new int[]{146}); //Jahoda
        addSentenceToWord(wordSentenceJoinArray, 370, new int[]{148}); //Sladké
        addSentenceToWord(wordSentenceJoinArray, 371, new int[]{148, 156}); //Kyslé
        addSentenceToWord(wordSentenceJoinArray, 371, new int[]{149}); //Chutné
        addSentenceToWord(wordSentenceJoinArray, 373, new int[]{155}); //Čerstvé
        addSentenceToWord(wordSentenceJoinArray, 374, new int[]{151, 152}); //Ovocie
        addSentenceToWord(wordSentenceJoinArray, 378, new int[]{163}); //Mrkva
        addSentenceToWord(wordSentenceJoinArray, 379, new int[]{156, 163}); //Kapusta
        addSentenceToWord(wordSentenceJoinArray, 382, new int[]{154}); //Zemiaky
        addSentenceToWord(wordSentenceJoinArray, 385, new int[]{154}); //Ošúpať
        addSentenceToWord(wordSentenceJoinArray, 386, new int[]{151, 152}); //Zelenina
        addSentenceToWord(wordSentenceJoinArray, 387, new int[]{157}); //Zdravá
        addSentenceToWord(wordSentenceJoinArray, 388, new int[]{155,156}); //Tržnica
        addSentenceToWord(wordSentenceJoinArray, 389, new int[]{150}); //Kúpiť
        addSentenceToWord(wordSentenceJoinArray, 390, new int[]{158}); //Jar
        addSentenceToWord(wordSentenceJoinArray, 392, new int[]{160, 169}); //Jeseň
        addSentenceToWord(wordSentenceJoinArray, 393, new int[]{136, 168}); //Zima
        addSentenceToWord(wordSentenceJoinArray, 396, new int[]{163}); //Záhrada
        addSentenceToWord(wordSentenceJoinArray, 397, new int[]{158, 159}); //Kvet
        addSentenceToWord(wordSentenceJoinArray, 398, new int[]{161}); //Tráva
        addSentenceToWord(wordSentenceJoinArray, 400, new int[]{131, 159}); //Krásne
        addSentenceToWord(wordSentenceJoinArray, 401, new int[]{158}); //Sadiť
        addSentenceToWord(wordSentenceJoinArray, 402, new int[]{161, 169}); //Rásť
        addSentenceToWord(wordSentenceJoinArray, 404, new int[]{160}); //Oberať
        addSentenceToWord(wordSentenceJoinArray, 406, new int[]{166}); //Hora
        addSentenceToWord(wordSentenceJoinArray, 407, new int[]{165}); //Horúco
        addSentenceToWord(wordSentenceJoinArray, 411, new int[]{167}); //Vianoce
        addSentenceToWord(wordSentenceJoinArray, 412, new int[]{168}); //Oblečenie
        addSentenceToWord(wordSentenceJoinArray, 413, new int[]{164}); //Sneh
        addSentenceToWord(wordSentenceJoinArray, 414, new int[]{166}); //Vietor
        addSentenceToWord(wordSentenceJoinArray, 415, new int[]{166}); //Silný
        addSentenceToWord(wordSentenceJoinArray, 419, new int[]{168}); //Hrubé

        for (WordSentenceJoin wordSentenceJoin : wordSentenceJoinArray)
            db.wordSentenceJoinDao().insertAll(wordSentenceJoin);
    }

    private static class PopulateDbAsync extends AsyncTask<Void, Void, Void> {

        private final AppDatabase mDb;

        PopulateDbAsync(AppDatabase db) {
            mDb = db;
        }

        @Override
        protected Void doInBackground(final Void... params) {

            populateWithLectionData(mDb);
            populateWithWordData(mDb);
            populateWithSentenceData(mDb);
            joinWordWithSentence(mDb);

            return null;
        }

    }
}