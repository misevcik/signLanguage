package sk.doreto.signlanguage.database;


import android.os.AsyncTask;
import android.util.Log;

import androidx.annotation.NonNull;

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
                new Word(3, "On/Ona", 0, "test.mp3", "testSide.mp3", true),
                new Word(4, "Áno", 0, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(5, "Nie", 0, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(6, "Nepočujúci", 0, "test.mp3", "testSide.mp3", true),
                new Word(7, "Počujúci", 0, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(8, "Rozumieť", 0, "test.mp3", "testSide.mp3", true),
                new Word(9, "Nerozumieť", 0,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(10, "Nedoslýchaví", 0,  "test.mp3", "testSide.mp3", true),
                new Word(11, "Muž", 0, "test.mp3", "testSide.mp3", true),
                new Word(12, "Žena", 0,  "test.mp3", "testSide.mp3", true),
                new Word(13, "Chlapec", 0,  "test.mp3", "testSide.mp3", true),
                new Word(14, "Dievča", 0,  "test.mp3", "testSide.mp3", true),

                //Lesson 2 - Prvy kontakt II
                new Word(15, "Meno", 1, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(16, "Moje", 1,"lection1_ano", "lection1_ano1", true),
                new Word(17, "Tvoje", 1,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(18, "Jeho/Jej", 1, "test.mp3", "testSide.mp3", true),
                new Word(19, "Kto", 1, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(20, "My", 1, "test.mp3", "testSide.mp3", true),
                new Word(21, "Vy", 1, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(22, "Rovnako", 1, "test.mp3", "testSide.mp3", true),
                new Word(23, "Čo", 1,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(24, "Ako", 1,  "test.mp3", "testSide.mp3", true),
                new Word(25, "Alebo", 1, "test.mp3", "testSide.mp3", true),
                new Word(26, "Dobre", 1,  "test.mp3", "testSide.mp3", true),
                new Word(27, "Zle", 1,  "test.mp3", "testSide.mp3", true),
                new Word(28, "Prosiť", 1,  "test.mp3", "testSide.mp3", true),
                new Word(29, "Prepáč", 1,  "test.mp3", "testSide.mp3", true),

                //Lesson 3 - Prvy kontakt III
                new Word(30, "Ráno", 2, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(31, "Obed", 2,"lection1_ano", "lection1_ano1", true),
                new Word(32, "Poobede", 2,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(33, "Večer", 2, "test.mp3", "testSide.mp3", true),
                new Word(34, "Noc", 2, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(35, "Deň", 2, "test.mp3", "testSide.mp3", true),
                new Word(36, "Osoba", 2, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(37, "Kamarát/ka", 2, "test.mp3", "testSide.mp3", true),
                new Word(38, "Kolega/Kolegyňa", 2,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(39, "Ďakujem", 2,  "test.mp3", "testSide.mp3", true),
                new Word(40, "Pozdraviť", 2, "test.mp3", "testSide.mp3", true),
                new Word(41, "Poznať", 2,  "test.mp3", "testSide.mp3", true),
                new Word(42, "Tešiť sa", 2,  "test.mp3", "testSide.mp3", true),
                new Word(43, "Stretnúť", 2,  "test.mp3", "testSide.mp3", true),
                new Word(44, "Opakovať", 2,  "test.mp3", "testSide.mp3", true),

                //Lesson 4 - Rodina I
                new Word(45, "Mama", 3, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(46, "Otec", 3,"lection1_ano", "lection1_ano1", true),
                new Word(47, "Dcéra", 3,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(48, "Syn", 3, "test.mp3", "testSide.mp3", true),
                new Word(49, "Rodina", 3, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(50, "Brat", 3, "test.mp3", "testSide.mp3", true),
                new Word(51, "Sestra", 3, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(52, "Deti", 3, "test.mp3", "testSide.mp3", true),
                new Word(53, "Mám", 3,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(54, "Nemám", 3,  "test.mp3", "testSide.mp3", true),
                new Word(55, "Babka", 3, "test.mp3", "testSide.mp3", true),
                new Word(56, "Dedko", 3,  "test.mp3", "testSide.mp3", true),
                new Word(57, "Dieťa", 3,  "test.mp3", "testSide.mp3", true),
                new Word(58, "Ženatý/Vydatá", 3,  "test.mp3", "testSide.mp3", true),
                new Word(59, "Slobodný/á", 3,  "test.mp3", "testSide.mp3", true),

                //Lesson 5 - Rodina II
                new Word(60, "Vnuk", 4, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(61, "Vnučka", 4,"lection1_ano", "lection1_ano1", true),
                new Word(62, "Manžel/ka", 4,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(63, "Rozvedený/á", 4, "test.mp3", "testSide.mp3", true),
                new Word(64, "Manželia", 4, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(65, "Frajer/ka", 4, "test.mp3", "testSide.mp3", true),
                new Word(66, "Priateľ/ka", 4, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(67, "Druh/Družka\"", 4, "test.mp3", "testSide.mp3", true),
                new Word(68, "Teta", 4,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(69, "Ujo", 4,  "test.mp3", "testSide.mp3", true),
                new Word(70, "Žiť", 4, "test.mp3", "testSide.mp3", true),
                new Word(71, "Spolu", 4,  "test.mp3", "testSide.mp3", true),
                new Word(72, "Rozvod/Rozchod", 4,  "test.mp3", "testSide.mp3", true),
                new Word(73, "Rande", 4,  "test.mp3", "testSide.mp3", true),
                new Word(74, "Láska", 4,  "test.mp3", "testSide.mp3", true),

                //Lesson 6 - Čísla I.
                new Word(75, "0 - 5", 5, "lection1_ahoj", "lection1_ahoj1", false),
                new Word(76, "6 - 10", 5,"lection1_ano", "lection1_ano1", false),
                new Word(77, "11 - 15", 5,"lection1_chlapec", "lection1_chlapec1", false),
                new Word(78, "16 - 20", 5, "test.mp3", "testSide.mp3", false),
                new Word(79, "21 - 25", 5, "ahoj.mp3", "ahojSide.mp3", false),
                new Word(80, "26 - 30", 5, "test.mp3", "testSide.mp3", false),
                new Word(81, "31 - 35", 5, "ahoj.mp3", "ahojSide.mp3", false),
                new Word(82, "46 - 50", 5, "test.mp3", "testSide.mp3", false),
                new Word(83, "51 - 55", 5,  "ahoj.mp3", "ahojSide.mp3", false),
                new Word(84, "66 - 70", 5,  "test.mp3", "testSide.mp3", false),
                new Word(85, "81 - 85", 5, "test.mp3", "testSide.mp3", false),
                new Word(86, "96 - 99", 5,  "test.mp3", "testSide.mp3", false),
                new Word(87, "Číslo", 5,  "test.mp3", "testSide.mp3", true),
                new Word(88, "+/-/*/:/=", 5,  "test.mp3", "testSide.mp3", false),
                new Word(89, "Rokov", 5,  "test.mp3", "testSide.mp3", true),

                //Lesson 7 - Čísla II.
                new Word(90, "100 - 500", 6, "lection1_ahoj", "lection1_ahoj1", false),
                new Word(91, "600 - 900", 6,"lection1_ano", "lection1_ano1", false),
                new Word(92, "1000 - 5000", 6,"lection1_chlapec", "lection1_chlapec1", false),
                new Word(93, "6000 - 10000", 6, "test.mp3", "testSide.mp3", false),
                new Word(94, "200000 - 50000", 6, "ahoj.mp3", "ahojSide.mp3", false),
                new Word(95, "100 000", 6, "test.mp3", "testSide.mp3", false),
                new Word(96, "250 000", 6, "ahoj.mp3", "ahojSide.mp3", false),
                new Word(97, "700 000", 6, "test.mp3", "testSide.mp3", false),
                new Word(98, "1 000 000", 6,  "ahoj.mp3", "ahojSide.mp3", false),
                new Word(99, "10 000 000", 6,  "test.mp3", "testSide.mp3", false),
                new Word(100, "Starý", 6, "test.mp3", "testSide.mp3", true),
                new Word(101, "Mladý", 6,  "test.mp3", "testSide.mp3", true),
                new Word(102, "Koľko", 6,  "test.mp3", "testSide.mp3", true),
                new Word(103, "Správne", 6,  "test.mp3", "testSide.mp3", true),
                new Word(104, "Nesprávne", 6,  "test.mp3", "testSide.mp3", true),

                //Lesson 8 - Materiály a farby I.
                new Word(105, "Farba", 7, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(106, "Biela", 7,"lection1_ano", "lection1_ano1", true),
                new Word(107, "Žltá", 7,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(108, "Ružová", 7, "test.mp3", "testSide.mp3", true),
                new Word(109, "Oranžová", 7, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(110, "Červená", 7, "test.mp3", "testSide.mp3", true),
                new Word(111, "Fialová", 7, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(112, "Svetlá", 7, "test.mp3", "testSide.mp3", true),
                new Word(113, "Tmavá", 7,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(114, "Farebná", 7,  "test.mp3", "testSide.mp3", true),
                new Word(115, "Milovať", 7, "test.mp3", "testSide.mp3", true),
                new Word(116, "Neznášať", 7,  "test.mp3", "testSide.mp3", true),
                new Word(117, "Pekná", 7,  "test.mp3", "testSide.mp3", true),
                new Word(118, "Škaredá", 7,  "test.mp3", "testSide.mp3", true),
                new Word(119, "Moderná", 7,  "test.mp3", "testSide.mp3", true),

                //Lesson 9 - Materiály a farby II.
                new Word(120, "Modrá", 8, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(121, "Hnedá", 8,"lection1_ano", "lection1_ano1", true),
                new Word(122, "Zelená", 8,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(123, "Sivá", 8, "test.mp3", "testSide.mp3", true),
                new Word(124, "Čierna", 8, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(125, "Materiál", 8, "test.mp3", "testSide.mp3", true),
                new Word(126, "Papier", 8, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(127, "Drevo", 8, "test.mp3", "testSide.mp3", true),
                new Word(128, "Železo/Kov", 8,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(129, "Sklo", 8,  "test.mp3", "testSide.mp3", true),
                new Word(130, "Keramika", 8, "test.mp3", "testSide.mp3", true),
                new Word(131, "Látka", 8,  "test.mp3", "testSide.mp3", true),
                new Word(132, "Koža", 8,  "test.mp3", "testSide.mp3", true),
                new Word(133, "Tvrdá", 8,  "test.mp3", "testSide.mp3", true),
                new Word(134, "Mäkká", 8,  "test.mp3", "testSide.mp3", true),

                //Lesson 10 - Bývanie I.
                new Word(135, "Byt", 9, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(136, "Dom", 9,"lection1_ano", "lection1_ano1", true),
                new Word(137, "Panelák", 9,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(138, "Doma", 9, "test.mp3", "testSide.mp3", true),
                new Word(139, "Domov", 9, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(140, "Sused/ka", 9, "test.mp3", "testSide.mp3", true),
                new Word(141, "Izba", 9, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(142, "Poschodie", 9, "test.mp3", "testSide.mp3", true),
                new Word(143, "Podnájom", 9,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(144, "Prenájom", 9,  "test.mp3", "testSide.mp3", true),
                new Word(145, "Nový", 9, "test.mp3", "testSide.mp3", true),
                new Word(146, "Vlastný", 9,  "test.mp3", "testSide.mp3", true),
                new Word(147, "Bývať", 9,  "test.mp3", "testSide.mp3", true),
                new Word(148, "Kde", 9,  "test.mp3", "testSide.mp3", true),
                new Word(149, "Kam", 9,  "test.mp3", "testSide.mp3", true),

                //Lesson 11 - Bývanie II.
                new Word(150, "Ubytovanie", 10, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(151, "Internát", 10,"lection1_ano", "lection1_ano1", true),
                new Word(152, "Chata", 10,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(153, "Môže", 10, "test.mp3", "testSide.mp3", true),
                new Word(154, "Nemôže", 10, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(155, "Pozemok", 10, "test.mp3", "testSide.mp3", true),
                new Word(156, "Prísť", 10, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(157, "Odísť", 10, "test.mp3", "testSide.mp3", true),
                new Word(158, "Sťahovať", 10,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(159, "Navštíviť", 10,  "test.mp3", "testSide.mp3", true),
                new Word(160, "Malý", 10, "test.mp3", "testSide.mp3", true),
                new Word(161, "Veľký", 10,  "test.mp3", "testSide.mp3", true),
                new Word(162, "Preč", 10,  "test.mp3", "testSide.mp3", true),
                new Word(163, "Chodiť", 10,  "test.mp3", "testSide.mp3", true),
                new Word(164, "Isť do", 10,  "test.mp3", "testSide.mp3", true),

                //Lesson 12 - Inštitúcie I.
                new Word(165, "Nemocnica", 11, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(166, "Škola", 11,"lection1_ano", "lection1_ano1", true),
                new Word(167, "Pošta", 11,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(168, "Polícia", 11, "test.mp3", "testSide.mp3", true),
                new Word(169, "Televízia", 11, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(170, "Kostol", 11, "test.mp3", "testSide.mp3", true),
                new Word(171, "Úrad", 11, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(172, "Reštaurácia", 11, "test.mp3", "testSide.mp3", true),
                new Word(173, "Banka", 11,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(174, "Obchod", 11,  "test.mp3", "testSide.mp3", true),
                new Word(175, "Vedľa", 11, "test.mp3", "testSide.mp3", true),
                new Word(176, "Blízko", 11,  "test.mp3", "testSide.mp3", true),
                new Word(177, "Ďaleko", 11,  "test.mp3", "testSide.mp3", true),
                new Word(178, "Otvorené", 11,  "test.mp3", "testSide.mp3", true),
                new Word(179, "Zatvorené", 11,  "test.mp3", "testSide.mp3", true),

                //Lesson 13 - Inštitúcie II.
                new Word(180, "Kino", 12, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(181, "Múzeum", 12,"lection1_ano", "lection1_ano1", true),
                new Word(182, "Hrad", 12,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(183, "Zámok", 12, "test.mp3", "testSide.mp3", true),
                new Word(184, "Divadlo", 12, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(185, "Centrum", 12, "test.mp3", "testSide.mp3", true),
                new Word(186, "Námestie", 12, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(187, "Ulica", 12, "test.mp3", "testSide.mp3", true),
                new Word(188, "Park", 12,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(189, "Hotel", 12,  "test.mp3", "testSide.mp3", true),
                new Word(190, "Služba", 12, "test.mp3", "testSide.mp3", true),
                new Word(191, "Firma", 12,  "test.mp3", "testSide.mp3", true),
                new Word(192, "Oproti", 12,  "test.mp3", "testSide.mp3", true),
                new Word(193, "Všetko", 12,  "test.mp3", "testSide.mp3", true),
                new Word(194, "Prechádzať", 12,  "test.mp3", "testSide.mp3", true),

                //Lesson 14 - Mestá I.
                new Word(195, "Bratislava", 13, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(196, "Blava", 13,"lection1_ano", "lection1_ano1", true),
                new Word(197, "Košice", 13,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(198, "Nitra", 13, "test.mp3", "testSide.mp3", true),
                new Word(199, "Žilina", 13, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(200, "Banská Bystrica", 13, "test.mp3", "testSide.mp3", true),
                new Word(201, "Lučenec", 13, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(202, "Poprad", 13, "test.mp3", "testSide.mp3", true),
                new Word(203, "Liptovský Mikuláš", 13,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(204, "Prešov", 13,  "test.mp3", "testSide.mp3", true),
                new Word(205, "Trnava", 13, "test.mp3", "testSide.mp3", true),
                new Word(206, "Mesto", 13,  "test.mp3", "testSide.mp3", true),
                new Word(207, "Dedina", 13,  "test.mp3", "testSide.mp3", true),
                new Word(208, "Okres", 13,  "test.mp3", "testSide.mp3", true),
                new Word(209, "Pekné", 13,  "test.mp3", "testSide.mp3", true),
                new Word(210, "Škaredé", 13,  "test.mp3", "testSide.mp3", true),

                //Lesson 15 - Mestá II.
                new Word(211, "Zvolen", 14, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(212, "Trenčín", 14,"lection1_ano", "lection1_ano1", true),
                new Word(213, "Prievidza", 14,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(214, "Martin", 14, "test.mp3", "testSide.mp3", true),
                new Word(215, "Púchov", 14, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(216, "Vysoké Tatry", 14, "test.mp3", "testSide.mp3", true),
                new Word(217, "Ružomberok", 14, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(218, "Žiar nad Hronom", 14, "test.mp3", "testSide.mp3", true),
                new Word(219, "Dunajská Streda", 14,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(220, "Piešťany", 14,  "test.mp3", "testSide.mp3", true),
                new Word(221, "Chcieť", 14, "test.mp3", "testSide.mp3", true),
                new Word(222, "Nechcieť", 14,  "test.mp3", "testSide.mp3", true),
                new Word(223, "Pochádzať", 14,  "test.mp3", "testSide.mp3", true),
                new Word(224, "Cestovať", 14,  "test.mp3", "testSide.mp3", true),
                new Word(225, "Odkiaľ", 14,  "test.mp3", "testSide.mp3", true),

                //Lesson 16 - Doprava I.
                new Word(226, "Auto", 15, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(227, "Motorka", 15,"lection1_ano", "lection1_ano1", true),
                new Word(228, "Autobus", 15,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(229, "Vlak", 15, "test.mp3", "testSide.mp3", true),
                new Word(230, "Trolejbus", 15, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(231, "Električka", 15, "test.mp3", "testSide.mp3", true),
                new Word(232, "Lietadlo", 15, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(233, "Bicykel", 15, "test.mp3", "testSide.mp3", true),
                new Word(234, "Loď", 15,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(235, "Doprava", 15,  "test.mp3", "testSide.mp3", true),
                new Word(236, "Jazdiť", 15, "test.mp3", "testSide.mp3", true),
                new Word(237, "Pomaly", 15,  "test.mp3", "testSide.mp3", true),
                new Word(238, "Rýchlo", 15,  "test.mp3", "testSide.mp3", true),
                new Word(239, "Drahe", 15,  "test.mp3", "testSide.mp3", true),
                new Word(240, "Lacne", 15,  "test.mp3", "testSide.mp3", true),

                //Lesson 17 - Doprava II.
                new Word(241, "Metro", 16, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(242, "Most", 16,"lection1_ano", "lection1_ano1", true),
                new Word(243, "Diaľnica", 16,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(244, "Cesta", 16, "test.mp3", "testSide.mp3", true),
                new Word(245, "Parkovisko", 16, "test.mp3", "testSide.mp3", true),
                new Word(246, "Taxi", 16, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(247, "Semafor", 16, "test.mp3", "testSide.mp3", true),
                new Word(248, "Nehoda", 16,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(249, "Turbulencia", 16,  "test.mp3", "testSide.mp3", true),
                new Word(250, "Rieka", 16, "test.mp3", "testSide.mp3", true),
                new Word(251, "Šofér", 16,  "test.mp3", "testSide.mp3", true),
                new Word(252, "Pri", 16,  "test.mp3", "testSide.mp3", true),
                new Word(253, "Problém", 16,  "test.mp3", "testSide.mp3", true),
                new Word(254, "Pokuta", 16,  "test.mp3", "testSide.mp3", true),

                //Lesson 18 - Čas I.
                new Word(255, "Čas", 17, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(256, "Sekudna", 17,"lection1_ano", "lection1_ano1", true),
                new Word(257, "Minúta", 17,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(258, "Hodina", 17, "test.mp3", "testSide.mp3", true),
                new Word(259, "Hodiny", 17, "test.mp3", "testSide.mp3", true),
                new Word(260, "1h - 5h", 17, "ahoj.mp3", "ahojSide.mp3", false),
                new Word(261, "6h - 10h", 17, "test.mp3", "testSide.mp3", false),
                new Word(262, "11h - 12h", 17,  "ahoj.mp3", "ahojSide.mp3", false),
                new Word(263, "o 1h - o 6h", 17,  "test.mp3", "testSide.mp3", false),
                new Word(264, "o 7h - o 12h", 17, "test.mp3", "testSide.mp3", false),
                new Word(265, "O koľkej", 17,  "test.mp3", "testSide.mp3", true),
                new Word(266, "Kedy", 17,  "test.mp3", "testSide.mp3", true),
                new Word(267, "Meškať", 17,  "test.mp3", "testSide.mp3", true),
                new Word(268, "Čakať", 17,  "test.mp3", "testSide.mp3", true),
                new Word(269, "Vstávať", 17,  "test.mp3", "testSide.mp3", true),

                //Lesson 19 - Čas II.
                new Word(270, "Práca", 18, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(271, "Dovolenka", 18,"lection1_ano", "lection1_ano1", true),
                new Word(272, "Voľno", 18,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(273, "Teraz", 18, "test.mp3", "testSide.mp3", true),
                new Word(274, "Každý", 18, "test.mp3", "testSide.mp3", true),
                new Word(275, "Pravidelne", 18, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(276, "Nepravidelne", 18, "test.mp3", "testSide.mp3", true),
                new Word(277, "Bude", 18,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(278, "Bolo", 18,  "test.mp3", "testSide.mp3", true),
                new Word(279, "Jesť", 18, "test.mp3", "testSide.mp3", true),
                new Word(280, "Odpočívať", 18,  "test.mp3", "testSide.mp3", true),
                new Word(281, "Pred", 18,  "test.mp3", "testSide.mp3", true),
                new Word(282, "Po", 18,  "test.mp3", "testSide.mp3", true),
                new Word(283, "Asi", 18,  "test.mp3", "testSide.mp3", true),
                new Word(284, "Až", 18,  "test.mp3", "testSide.mp3", true),

                //Lesson 20 - Kalendár I.
                new Word(285, "Pondelok", 19, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(286, "Utorok", 19,"lection1_ano", "lection1_ano1", true),
                new Word(287, "Streda", 19,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(288, "Štvrtok", 19, "test.mp3", "testSide.mp3", true),
                new Word(289, "Piatok", 19, "test.mp3", "testSide.mp3", true),
                new Word(290, "Sobota", 19, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(291, "Nedeľa", 19, "test.mp3", "testSide.mp3", true),
                new Word(292, "Týždeň", 19,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(293, "Sviatok", 19,  "test.mp3", "testSide.mp3", true),
                new Word(294, "Dnes", 19, "test.mp3", "testSide.mp3", true),
                new Word(295, "Včera", 19,  "test.mp3", "testSide.mp3", true),
                new Word(296, "Zajtra", 19,  "test.mp3", "testSide.mp3", true),
                new Word(297, "Kalendár", 19,  "test.mp3", "testSide.mp3", true),
                new Word(298, "Prázdniny", 19,  "test.mp3", "testSide.mp3", true),
                new Word(299, "Víkend", 19,  "test.mp3", "testSide.mp3", true),

                //Lesson 21 - Kalendár II.
                new Word(300, "Január", 20,  "test.mp3", "testSide.mp3", true),
                new Word(301, "Február", 20, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(302, "Marec", 20,"lection1_ano", "lection1_ano1", true),
                new Word(303, "Apríl", 20,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(304, "Máj", 20, "test.mp3", "testSide.mp3", true),
                new Word(305, "Jún", 20, "test.mp3", "testSide.mp3", true),
                new Word(306, "Júl", 20, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(307, "August", 20, "test.mp3", "testSide.mp3", true),
                new Word(308, "September", 20,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(309, "Október", 20,  "test.mp3", "testSide.mp3", true),
                new Word(310, "November", 20, "test.mp3", "testSide.mp3", true),
                new Word(311, "December", 20,  "test.mp3", "testSide.mp3", true),
                new Word(312, "Mesiac", 20,  "test.mp3", "testSide.mp3", true),
                new Word(313, "Rok", 20,  "test.mp3", "testSide.mp3", true),
                new Word(314, "Dátum", 20,  "test.mp3", "testSide.mp3", true),

                //Lesson 22 - Zvieratá I.
                new Word(315, "Pes", 21,  "test.mp3", "testSide.mp3", true),
                new Word(316, "Mačka", 21, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(317, "Sliepka", 21,"lection1_ano", "lection1_ano1", true),
                new Word(318, "Krava", 21,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(319, "Koza", 21, "test.mp3", "testSide.mp3", true),
                new Word(320, "Prasa", 21, "test.mp3", "testSide.mp3", true),
                new Word(321, "Kôn", 21, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(322, "Zajac", 21, "test.mp3", "testSide.mp3", true),
                new Word(323, "Ovca", 21,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(324, "Hus", 21,  "test.mp3", "testSide.mp3", true),
                new Word(325, "Farma", 21, "test.mp3", "testSide.mp3", true),
                new Word(326, "Dvor", 21,  "test.mp3", "testSide.mp3", true),
                new Word(327, "Kŕmiť", 21,  "test.mp3", "testSide.mp3", true),
                new Word(328, "Strážiť", 21,  "test.mp3", "testSide.mp3", true),
                new Word(329, "Chovať", 21,  "test.mp3", "testSide.mp3", true),

                //Lesson 23 - Zvieratá II.
                new Word(330, "Medveď", 22,  "test.mp3", "testSide.mp3", true),
                new Word(331, "Vlk", 22, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(332, "Jeleň", 22,"lection1_ano", "lection1_ano1", true),
                new Word(333, "Srna", 22,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(334, "Myš", 22, "test.mp3", "testSide.mp3", true),
                new Word(335, "Motýľ", 22, "test.mp3", "testSide.mp3", true),
                new Word(336, "Líška", 22, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(337, "Žaba", 22, "test.mp3", "testSide.mp3", true),
                new Word(338, "Veverička", 22,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(339, "Včela", 22,  "test.mp3", "testSide.mp3", true),
                new Word(340, "Les", 22, "test.mp3", "testSide.mp3", true),
                new Word(341, "Zviera", 22,  "test.mp3", "testSide.mp3", true),
                new Word(342, "Strom", 22,  "test.mp3", "testSide.mp3", true),
                new Word(343, "Báť sa", 22,  "test.mp3", "testSide.mp3", true),
                new Word(344, "Dôvod", 22,  "test.mp3", "testSide.mp3", true),

                //Lesson 24 - Zvieratá III.
                new Word(345, "Opica", 23,  "test.mp3", "testSide.mp3", true),
                new Word(346, "Gorila", 23, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(347, "Lev", 23,"lection1_ano", "lection1_ano1", true),
                new Word(348, "Tiger", 23,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(349, "Slon", 23, "test.mp3", "testSide.mp3", true),
                new Word(350, "Had", 23, "test.mp3", "testSide.mp3", true),
                new Word(351, "Krokodil", 23, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(352, "Žirafa", 23, "test.mp3", "testSide.mp3", true),
                new Word(353, "Korytnačka", 23,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(354, "Ťava", 23,  "test.mp3", "testSide.mp3", true),
                new Word(355, "ZOO", 23, "test.mp3", "testSide.mp3", true),
                new Word(356, "Nebezpečný", 23,  "test.mp3", "testSide.mp3", true),
                new Word(357, "Jedovatý", 23,  "test.mp3", "testSide.mp3", true),
                new Word(358, "Hrať", 23,  "test.mp3", "testSide.mp3", true),
                new Word(359, "Niektoré", 23,  "test.mp3", "testSide.mp3", true),

                //Lesson 25 - Ovocie
                new Word(360, "Jablko", 24,  "test.mp3", "testSide.mp3", true),
                new Word(361, "Pomaranč", 24, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(362, "Slivka", 24,"lection1_ano", "lection1_ano1", true),
                new Word(363, "Citron", 24,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(364, "Banán", 24, "test.mp3", "testSide.mp3", true),
                new Word(365, "Čerešne", 24, "test.mp3", "testSide.mp3", true),
                new Word(366, "Hrozno", 24, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(367, "Jahoda", 24, "test.mp3", "testSide.mp3", true),
                new Word(368, "Hruška", 24,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(369, "Broskyňa", 24,  "test.mp3", "testSide.mp3", true),
                new Word(370, "Sladké", 24, "test.mp3", "testSide.mp3", true),
                new Word(371, "Kyslé", 24,  "test.mp3", "testSide.mp3", true),
                new Word(372, "Chutné", 24,  "test.mp3", "testSide.mp3", true),
                new Word(373, "Čerstvé", 24,  "test.mp3", "testSide.mp3", true),
                new Word(374, "Ovocie", 24,  "test.mp3", "testSide.mp3", true),

                //Lesson 26 - Zelenina
                new Word(375, "Paradjaka", 25,  "test.mp3", "testSide.mp3", true),
                new Word(376, "Cibuľa", 25, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(377, "Paprika", 25,"lection1_ano", "lection1_ano1", true),
                new Word(378, "Mrkva", 25,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(379, "Kapusta", 25, "test.mp3", "testSide.mp3", true),
                new Word(380, "Kukurica", 25, "test.mp3", "testSide.mp3", true),
                new Word(381, "Uhorka", 25, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(382, "Zemiaky", 25, "test.mp3", "testSide.mp3", true),
                new Word(383, "Cesnak", 25,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(384, "Hrach", 25,  "test.mp3", "testSide.mp3", true),
                new Word(385, "Ošúpať", 25, "test.mp3", "testSide.mp3", true),
                new Word(386, "Zelenina", 25,  "test.mp3", "testSide.mp3", true),
                new Word(387, "Zdravá", 25,  "test.mp3", "testSide.mp3", true),
                new Word(388, "Tržnica", 25,  "test.mp3", "testSide.mp3", true),
                new Word(389, "Kúpiť", 25,  "test.mp3", "testSide.mp3", true),

                //Lesson 27 - Ročné obdobie I.
                new Word(390, "Jar", 26,  "test.mp3", "testSide.mp3", true),
                new Word(391, "Leto", 26, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(392, "Jeseň", 26,"lection1_ano", "lection1_ano1", true),
                new Word(393, "Zima", 26,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(394, "Teplo", 26, "test.mp3", "testSide.mp3", true),
                new Word(395, "Príroda", 26, "test.mp3", "testSide.mp3", true),
                new Word(396, "Záhrada", 26, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(397, "Kvet", 26, "test.mp3", "testSide.mp3", true),
                new Word(398, "Tráva", 26,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(399, "Počasie", 26,  "test.mp3", "testSide.mp3", true),
                new Word(400, "Krásne", 26, "test.mp3", "testSide.mp3", true),
                new Word(401, "Sadiť", 26,  "test.mp3", "testSide.mp3", true),
                new Word(402, "Rásť", 26,  "test.mp3", "testSide.mp3", true),
                new Word(403, "Kopať", 26,  "test.mp3", "testSide.mp3", true),
                new Word(404, "Oberať", 26,  "test.mp3", "testSide.mp3", true),

                //Lesson 28 - Ročné obdobie II.
                new Word(405, "More", 27,  "test.mp3", "testSide.mp3", true),
                new Word(406, "Hora", 27, "lection1_ahoj", "lection1_ahoj1", true),
                new Word(407, "Horúco", 27,"lection1_ano", "lection1_ano1", true),
                new Word(408, "Jazero", 27,"lection1_chlapec", "lection1_chlapec1", true),
                new Word(409, "List", 27, "test.mp3", "testSide.mp3", true),
                new Word(410, "Dážď", 27, "test.mp3", "testSide.mp3", true),
                new Word(411, "Vianoce", 27, "ahoj.mp3", "ahojSide.mp3", true),
                new Word(412, "Oblečenie", 27, "test.mp3", "testSide.mp3", true),
                new Word(413, "Sneh", 27,  "ahoj.mp3", "ahojSide.mp3", true),
                new Word(414, "Vietor", 27,  "test.mp3", "testSide.mp3", true),
                new Word(415, "Silný", 27, "test.mp3", "testSide.mp3", true),
                new Word(416, "Slabý", 27,  "test.mp3", "testSide.mp3", true),
                new Word(417, "Padať", 27,  "test.mp3", "testSide.mp3", true),
                new Word(418, "Tenké", 27,  "test.mp3", "testSide.mp3", true),
                new Word(419, "Hrubé", 27,  "test.mp3", "testSide.mp3", true),

                //Lesson 29 - ABECEDA
                new Word(420, "A, Á, Ä", 28,  "test.mp3", "testSide.mp3", false),
                new Word(421, "B", 28, "lection1_ahoj", "lection1_ahoj1", false),
                new Word(422, "C, Č", 28,"lection1_ano", "lection1_ano1", false),
                new Word(423, "D, Ď", 28,"lection1_chlapec", "lection1_chlapec1", false),
                new Word(424, "E, É", 28, "test.mp3", "testSide.mp3", false),
                new Word(425, "F", 28, "test.mp3", "testSide.mp3", false),
                new Word(426, "G", 28, "ahoj.mp3", "ahojSide.mp3", false),
                new Word(427, "H, CH", 28, "test.mp3", "testSide.mp3", false),
                new Word(428, "I, Í", 28,  "ahoj.mp3", "ahojSide.mp3", false),
                new Word(429, "J", 28,  "test.mp3", "testSide.mp3", false),
                new Word(430, "K", 28, "test.mp3", "testSide.mp3", false),
                new Word(431, "L, Ĺ, Ľ", 28,  "test.mp3", "testSide.mp3", false),
                new Word(432, "M", 28,  "test.mp3", "testSide.mp3", false),
                new Word(433, "N, Ň", 28,  "test.mp3", "testSide.mp3", false),
                new Word(434, "O, Ó, Ô", 28,  "test.mp3", "testSide.mp3", false),
                new Word(435, "P", 28,  "test.mp3", "testSide.mp3", false),
                new Word(436, "Q", 28,  "test.mp3", "testSide.mp3", false),
                new Word(437, "R, Ŕ", 28,  "test.mp3", "testSide.mp3", false),
                new Word(438, "S, Š", 28,  "test.mp3", "testSide.mp3", false),
                new Word(439, "T, Ť", 28,  "test.mp3", "testSide.mp3", false),
                new Word(440, "U, Ú", 28,  "test.mp3", "testSide.mp3", false),
                new Word(441, "V, W", 28,  "test.mp3", "testSide.mp3", false),
                new Word(442, "X", 28,  "test.mp3", "testSide.mp3", false),
                new Word(443, "Y, Ý", 28,  "test.mp3", "testSide.mp3", false),
                new Word(444, "Z, Ž", 28,  "test.mp3", "testSide.mp3", false)
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
                new Sentence(0, "On je nepočujúci.", ""),
                new Sentence(1, "Som chlapec.", ""),
                new Sentence(2, "Dievča je počujúca.", ""),
                new Sentence(3, "Rozumieš?", ""),
                new Sentence(4, "Ona je nedoslýchavá.", ""),
                new Sentence(5, "Ja ti nerozumiem.", ""),

                //Lesson 2 - - Prvy kontakt II
                new Sentence(6, "Moje meno je Michal.", ""),
                new Sentence(7, "Kto som?", ""),
                new Sentence(8, "Ako sa máš?", ""),
                new Sentence(9, "My sme počujúci.", ""),
                new Sentence(10, "Žena je zlá.", ""),
                new Sentence(11, "Prepáč, ja ti nerozumiem.", ""),

                //Lesson 3 - Prvy kontakt III
                new Sentence(12, "Dobre ráno.", ""),
                new Sentence(13, "Dobrý deň.", ""),
                new Sentence(14, "Dobrý večer!", ""),
                new Sentence(15, "Tvoja kamarátka je nepočujúca?", ""),
                new Sentence(16, "Ona pozná nepočujúceho muža.", ""),
                new Sentence(17, "Moja kolegyňa je nedoslýchavá.", ""),

                //Lesson 4 - Rodina I
                new Sentence(18, "Mám počujúcu sestru.", ""),
                new Sentence(19, "Poznám jeho rodičov.", ""),
                new Sentence(20, "Môj brat je ženatý.", ""),
                new Sentence(21, "On má nepočujúcu dcéru.", ""),
                new Sentence(22, "Nemám súrodencov.", ""),
                new Sentence(23, "Moje dieťa v noci spí.", ""),

                //Lesson 5 - Rodina I
                new Sentence(24, "Mám priateľku.", ""),
                new Sentence(25, "Má babka vnučku?", ""),
                new Sentence(26, "Moja mama je rozvedená.", ""),
                new Sentence(27, "Druh a družka majú deti.", ""),
                new Sentence(28, "Ako sa volá tvoj druh?", ""),
                new Sentence(29, "Manželia nemajú deti.", ""),

                //Lesson 6 - Cisla I
                new Sentence(30, "Mám tri kamarátky.", ""),
                new Sentence(31, "Mám štyroch bratov.", ""),
                new Sentence(32, "Môj otec má 37 rokov.", ""),
                new Sentence(33, "Moja kolegyňa je vydatá a má 4 deti.", ""),
                new Sentence(34, "Manželia sú spolu už 19 rokov.", ""),
                new Sentence(35, "Chlapec má 12 rokov.", ""),

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

    private static void joinWordWithSentence(AppDatabase db) {

        //TODO - improve data populate
        WordSentenceJoin wordSentenceJoinArray [] = {
                //Ja
                new WordSentenceJoin(1, 4),
                new WordSentenceJoin(1, 5),
                new WordSentenceJoin(1, 11),
                //On/Ona
                new WordSentenceJoin(3, 0),
                new WordSentenceJoin(3, 16),
                //Nepočujúci
                new WordSentenceJoin(6, 0),
                new WordSentenceJoin(6, 5),
                new WordSentenceJoin(6, 16),
                //Počujúci
                new WordSentenceJoin(7, 2),
                new WordSentenceJoin(7, 9),
                //Rozumieť
                new WordSentenceJoin(8, 3),
                //Nerozumieť
                new WordSentenceJoin(9, 5),
                new WordSentenceJoin(9, 11),
                //Nedoslýchaví
                new WordSentenceJoin(10, 4),
                new WordSentenceJoin(10, 17),
                //Muž
                new WordSentenceJoin(11, 16),
                //Žena
                new WordSentenceJoin(12, 10),
                //Chlapec
                new WordSentenceJoin(13, 1),
                //Dievča
                new WordSentenceJoin(14, 2),
                //Meno
                new WordSentenceJoin(15, 6),
                //Moje
                new WordSentenceJoin(16, 6),
                new WordSentenceJoin(16, 17),
                //Tvoje
                new WordSentenceJoin(17, 15),
                new WordSentenceJoin(17, 28),
                //Jeho/Jej
                new WordSentenceJoin(18, 19),
                //Kto
                new WordSentenceJoin(19, 7),
                //My
                new WordSentenceJoin(20, 9),
                //Ako
                new WordSentenceJoin(24, 8),
                //Dobre
                new WordSentenceJoin(26, 12),
                new WordSentenceJoin(26, 13),
                new WordSentenceJoin(26, 14),
                //Zle
                new WordSentenceJoin(27, 10),
                //Prepáč
                new WordSentenceJoin(29, 11),
                //Ráno
                new WordSentenceJoin(30, 12),
                //Večer
                new WordSentenceJoin(33, 14),
                new WordSentenceJoin(33, 115),
                //Noc
                new WordSentenceJoin(34, 64),
                //Deň
                new WordSentenceJoin(35, 13),
                new WordSentenceJoin(35, 108),
                //Kamarát/ka
                new WordSentenceJoin(37, 15),
                //Kolega/Kolegyňa
                new WordSentenceJoin(38, 17),
                new WordSentenceJoin(38, 59),
                //Poznať
                new WordSentenceJoin(41, 16),
                new WordSentenceJoin(41, 19),
                //Tešiť sa
                new WordSentenceJoin(42, 82),
                //Vnučka
                new WordSentenceJoin(61, 25),
                //Rozvedený/á
                new WordSentenceJoin(63, 26),
                //Manželia
                new WordSentenceJoin(64, 29),
                new WordSentenceJoin(64, 34),
                //Priateľ/ka
                new WordSentenceJoin(66, 24),
                new WordSentenceJoin(66, 38),
                //Druh/Družka
                new WordSentenceJoin(67, 27),
                new WordSentenceJoin(67, 28),
                //Teta
                new WordSentenceJoin(68, 137),
                //Žiť
                new WordSentenceJoin(70, 86),
                //Spolu
                new WordSentenceJoin(71, 34),
                //0 - 5
                new WordSentenceJoin(75, 30),
                new WordSentenceJoin(75, 31),
                new WordSentenceJoin(75, 33),
                //11 - 15
                new WordSentenceJoin(77, 35),
                //16 - 20
                new WordSentenceJoin(78, 34),
                //31 - 35
                new WordSentenceJoin(81, 32),
                //+/-/*/:/=
                new WordSentenceJoin(88, 37),
                new WordSentenceJoin(88, 40),
                //Rokov
                new WordSentenceJoin(89, 38),
                new WordSentenceJoin(89, 39),
                //Starý
                new WordSentenceJoin(100, 39),
                new WordSentenceJoin(100, 54),
                //Mladý
                new WordSentenceJoin(101, 41),
                //Koľko
                new WordSentenceJoin(102, 36),
                //Správne
                new WordSentenceJoin(103, 40),
                //Farba
                new WordSentenceJoin(105, 42),
                new WordSentenceJoin(105, 43),
                new WordSentenceJoin(105, 69),
                //Biela
                new WordSentenceJoin(106, 83),
                //Žltá
                new WordSentenceJoin(107, 44),
                new WordSentenceJoin(107, 69),
                //Oranžová
                new WordSentenceJoin(109, 42),
                //Červená
                new WordSentenceJoin(110, 42),
                new WordSentenceJoin(110, 45),
                //Fialová
                new WordSentenceJoin(111, 42),
                new WordSentenceJoin(111, 92),
                //Svetlá
                new WordSentenceJoin(112, 45),
                //Tmavá
                new WordSentenceJoin(113, 43),
                new WordSentenceJoin(113, 49),
                new WordSentenceJoin(113, 52),
                //Milovať
                new WordSentenceJoin(115, 44),
                new WordSentenceJoin(115, 45),
                //Neznášať
                new WordSentenceJoin(116, 44),
                new WordSentenceJoin(116, 80),
                //Pekná
                new WordSentenceJoin(117, 42),
                //Škaredá
                new WordSentenceJoin(118, 47),
                //Moderná
                new WordSentenceJoin(119, 52),
                new WordSentenceJoin(119, 53),
                //Modrá
                new WordSentenceJoin(120, 48),
                new WordSentenceJoin(120, 69),
                //Hnedá
                new WordSentenceJoin(121, 46),
                //Zelená
                new WordSentenceJoin(122, 50),
                //Sivá
                new WordSentenceJoin(123, 52),
                //Čierna
                new WordSentenceJoin(124, 44),
                new WordSentenceJoin(124, 46),
                //Drevo
                new WordSentenceJoin(127, 49),
                //Železo/Kov
                new WordSentenceJoin(128, 52),
                //Sklo
                new WordSentenceJoin(129, 53),
                //Keramika
                new WordSentenceJoin(130, 48),
                //Koža
                new WordSentenceJoin(132, 51),
                //Tvrdá
                new WordSentenceJoin(133, 51),
                //Byt
                new WordSentenceJoin(135, 55),
                new WordSentenceJoin(135, 61),
                //Dom
                new WordSentenceJoin(136, 54),
                new WordSentenceJoin(136, 83),
                //Doma
                new WordSentenceJoin(138, 137),
                //Domov
                new WordSentenceJoin(139, 56),
                //Sused/ka
                new WordSentenceJoin(140, 57),
                new WordSentenceJoin(140, 63),
                //Poschodie
                new WordSentenceJoin(142, 64),
                //Prenájom
                new WordSentenceJoin(44, 59),
                //Nový
                new WordSentenceJoin(145, 65),
                //Vlastný
                new WordSentenceJoin(146, 53),
                //Kde
                new WordSentenceJoin(148, 58),
                //Kam
                new WordSentenceJoin(149, 62),
                //Internát
                new WordSentenceJoin(151, 60),
                //Chata
                new WordSentenceJoin(152, 65),
                //Prísť
                new WordSentenceJoin(156, 113),
                //Odísť
                new WordSentenceJoin(157, 63),
                //Veľký
                new WordSentenceJoin(161, 61),
                //Preč
                new WordSentenceJoin(162, 63),
                //Chodiť
                new WordSentenceJoin(163, 68),
                new WordSentenceJoin(163, 95),
                new WordSentenceJoin(163, 109),
                //Isť do
                new WordSentenceJoin(164, 62),
                new WordSentenceJoin(164, 70)

                //Lesson 12 - Inštitúcie I.
                
        };

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