EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "R/C Compensation Tool"
Date "2021-09-27"
Rev "1"
Comp "Michael Schwingen"
Comment1 "<michael@schwingen.org>"
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Mechanical:MountingHole H1
U 1 1 5E6617BD
P 850 7150
F 0 "H1" H 950 7196 50  0000 L CNN
F 1 "MountingHole" H 950 7105 50  0000 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3" H 850 7150 50  0001 C CNN
F 3 "~" H 850 7150 50  0001 C CNN
	1    850  7150
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H3
U 1 1 5E6618F3
P 850 7400
F 0 "H3" H 950 7446 50  0000 L CNN
F 1 "MountingHole" H 950 7355 50  0000 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3" H 850 7400 50  0001 C CNN
F 3 "~" H 850 7400 50  0001 C CNN
	1    850  7400
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H2
U 1 1 5FA73882
P 1600 7150
F 0 "H2" H 1700 7196 50  0000 L CNN
F 1 "MountingHole" H 1700 7105 50  0000 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3" H 1600 7150 50  0001 C CNN
F 3 "~" H 1600 7150 50  0001 C CNN
	1    1600 7150
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H4
U 1 1 5FA73888
P 1600 7400
F 0 "H4" H 1700 7446 50  0000 L CNN
F 1 "MountingHole" H 1700 7355 50  0000 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3" H 1600 7400 50  0001 C CNN
F 3 "~" H 1600 7400 50  0001 C CNN
	1    1600 7400
	1    0    0    -1  
$EndComp
$Comp
L Switch:SW_DIP_x05 SW4
U 1 1 6152F40B
P 5400 5550
F 0 "SW4" H 5400 5083 50  0000 C CNN
F 1 "SW_DIP_x05" H 5400 5174 50  0000 C CNN
F 2 "Button_Switch_THT:SW_DIP_SPSTx05_Piano_10.8x14.26mm_W7.62mm_P2.54mm" H 5400 5550 50  0001 C CNN
F 3 "~" H 5400 5550 50  0001 C CNN
	1    5400 5550
	-1   0    0    1   
$EndComp
$Comp
L Device:C C20
U 1 1 6153048D
P 3450 5750
F 0 "C20" V 3600 5750 50  0000 C CNN
F 1 "22pF" V 3700 5750 50  0000 C CNN
F 2 "Capacitor_SMD:C_0603_1608Metric_Pad1.08x0.95mm_HandSolder" H 3488 5600 50  0001 C CNN
F 3 "~" H 3450 5750 50  0001 C CNN
	1    3450 5750
	0    1    1    0   
$EndComp
$Comp
L Device:C C19
U 1 1 61530AD2
P 3800 5650
F 0 "C19" V 4050 5600 50  0000 C CNN
F 1 "33pF" V 4150 5650 50  0000 C CNN
F 2 "Capacitor_SMD:C_0603_1608Metric_Pad1.08x0.95mm_HandSolder" H 3838 5500 50  0001 C CNN
F 3 "~" H 3800 5650 50  0001 C CNN
	1    3800 5650
	0    1    1    0   
$EndComp
$Comp
L Device:C C18
U 1 1 61530F68
P 4150 5550
F 0 "C18" V 4500 5550 50  0000 C CNN
F 1 "47pF" V 4600 5550 50  0000 C CNN
F 2 "Capacitor_SMD:C_0603_1608Metric_Pad1.08x0.95mm_HandSolder" H 4188 5400 50  0001 C CNN
F 3 "~" H 4150 5550 50  0001 C CNN
	1    4150 5550
	0    1    1    0   
$EndComp
$Comp
L Device:C C16
U 1 1 61531D89
P 4850 5350
F 0 "C16" V 5400 5350 50  0000 C CNN
F 1 "100pF" V 5500 5350 50  0000 C CNN
F 2 "Capacitor_SMD:C_0603_1608Metric_Pad1.08x0.95mm_HandSolder" H 4888 5200 50  0001 C CNN
F 3 "~" H 4850 5350 50  0001 C CNN
	1    4850 5350
	0    1    1    0   
$EndComp
$Comp
L Switch:SW_DIP_x05 SW3
U 1 1 61537B16
P 5400 4700
F 0 "SW3" H 5400 4233 50  0000 C CNN
F 1 "SW_DIP_x05" H 5400 4324 50  0000 C CNN
F 2 "Button_Switch_THT:SW_DIP_SPSTx05_Piano_10.8x14.26mm_W7.62mm_P2.54mm" H 5400 4700 50  0001 C CNN
F 3 "~" H 5400 4700 50  0001 C CNN
	1    5400 4700
	-1   0    0    1   
$EndComp
$Comp
L Device:C C15
U 1 1 61537B5A
P 3450 4900
F 0 "C15" V 3600 4900 50  0000 C CNN
F 1 "150pF" V 3700 4900 50  0000 C CNN
F 2 "Capacitor_SMD:C_0603_1608Metric_Pad1.08x0.95mm_HandSolder" H 3488 4750 50  0001 C CNN
F 3 "~" H 3450 4900 50  0001 C CNN
	1    3450 4900
	0    1    1    0   
$EndComp
$Comp
L Device:C C14
U 1 1 61537B64
P 3800 4800
F 0 "C14" V 4050 4750 50  0000 C CNN
F 1 "220pF" V 4150 4800 50  0000 C CNN
F 2 "Capacitor_SMD:C_0603_1608Metric_Pad1.08x0.95mm_HandSolder" H 3838 4650 50  0001 C CNN
F 3 "~" H 3800 4800 50  0001 C CNN
	1    3800 4800
	0    1    1    0   
$EndComp
$Comp
L Device:C C13
U 1 1 61537B6E
P 4150 4700
F 0 "C13" V 4500 4700 50  0000 C CNN
F 1 "330pF" V 4600 4700 50  0000 C CNN
F 2 "Capacitor_SMD:C_0603_1608Metric_Pad1.08x0.95mm_HandSolder" H 4188 4550 50  0001 C CNN
F 3 "~" H 4150 4700 50  0001 C CNN
	1    4150 4700
	0    1    1    0   
$EndComp
$Comp
L Device:C C12
U 1 1 61537B78
P 4500 4600
F 0 "C12" V 4950 4600 50  0000 C CNN
F 1 "470pF" V 5050 4600 50  0000 C CNN
F 2 "Capacitor_SMD:C_0603_1608Metric_Pad1.08x0.95mm_HandSolder" H 4538 4450 50  0001 C CNN
F 3 "~" H 4500 4600 50  0001 C CNN
	1    4500 4600
	0    1    1    0   
$EndComp
$Comp
L Device:C C11
U 1 1 61537B82
P 4850 4500
F 0 "C11" V 5400 4500 50  0000 C CNN
F 1 "680pF" V 5500 4500 50  0000 C CNN
F 2 "Capacitor_SMD:C_0603_1608Metric_Pad1.08x0.95mm_HandSolder" H 4888 4350 50  0001 C CNN
F 3 "~" H 4850 4500 50  0001 C CNN
	1    4850 4500
	0    1    1    0   
$EndComp
$Comp
L Switch:SW_DIP_x05 SW2
U 1 1 6153B7C8
P 5400 3850
F 0 "SW2" H 5400 3383 50  0000 C CNN
F 1 "SW_DIP_x05" H 5400 3474 50  0000 C CNN
F 2 "Button_Switch_THT:SW_DIP_SPSTx05_Piano_10.8x14.26mm_W7.62mm_P2.54mm" H 5400 3850 50  0001 C CNN
F 3 "~" H 5400 3850 50  0001 C CNN
	1    5400 3850
	-1   0    0    1   
$EndComp
$Comp
L Device:C C10
U 1 1 6153B978
P 3450 4050
F 0 "C10" V 3600 4050 50  0000 C CNN
F 1 "1nF" V 3700 4050 50  0000 C CNN
F 2 "Capacitor_SMD:C_0603_1608Metric_Pad1.08x0.95mm_HandSolder" H 3488 3900 50  0001 C CNN
F 3 "~" H 3450 4050 50  0001 C CNN
	1    3450 4050
	0    1    1    0   
$EndComp
$Comp
L Device:C C9
U 1 1 6153B982
P 3800 3950
F 0 "C9" V 4050 3900 50  0000 C CNN
F 1 "1.5nF" V 4150 3950 50  0000 C CNN
F 2 "Capacitor_SMD:C_0603_1608Metric_Pad1.08x0.95mm_HandSolder" H 3838 3800 50  0001 C CNN
F 3 "~" H 3800 3950 50  0001 C CNN
	1    3800 3950
	0    1    1    0   
$EndComp
$Comp
L Device:C C8
U 1 1 6153B98C
P 4150 3850
F 0 "C8" V 4500 3850 50  0000 C CNN
F 1 "2.2nF" V 4600 3850 50  0000 C CNN
F 2 "Capacitor_SMD:C_0603_1608Metric_Pad1.08x0.95mm_HandSolder" H 4188 3700 50  0001 C CNN
F 3 "~" H 4150 3850 50  0001 C CNN
	1    4150 3850
	0    1    1    0   
$EndComp
$Comp
L Device:C C7
U 1 1 6153B996
P 4500 3750
F 0 "C7" V 4950 3750 50  0000 C CNN
F 1 "3.3nF" V 5050 3750 50  0000 C CNN
F 2 "Capacitor_SMD:C_0603_1608Metric_Pad1.08x0.95mm_HandSolder" H 4538 3600 50  0001 C CNN
F 3 "~" H 4500 3750 50  0001 C CNN
	1    4500 3750
	0    1    1    0   
$EndComp
$Comp
L Device:C C6
U 1 1 6153B9A0
P 4850 3650
F 0 "C6" V 5400 3650 50  0000 C CNN
F 1 "4.7nF" V 5500 3650 50  0000 C CNN
F 2 "Capacitor_SMD:C_0603_1608Metric_Pad1.08x0.95mm_HandSolder" H 4888 3500 50  0001 C CNN
F 3 "~" H 4850 3650 50  0001 C CNN
	1    4850 3650
	0    1    1    0   
$EndComp
$Comp
L Switch:SW_DIP_x05 SW1
U 1 1 6153DA29
P 5400 3000
F 0 "SW1" H 5400 2533 50  0000 C CNN
F 1 "SW_DIP_x05" H 5400 2624 50  0000 C CNN
F 2 "Button_Switch_THT:SW_DIP_SPSTx05_Piano_10.8x14.26mm_W7.62mm_P2.54mm" H 5400 3000 50  0001 C CNN
F 3 "~" H 5400 3000 50  0001 C CNN
	1    5400 3000
	-1   0    0    1   
$EndComp
$Comp
L Device:C C5
U 1 1 6153DC71
P 3450 3200
F 0 "C5" V 3600 3200 50  0000 C CNN
F 1 "6.8nF" V 3700 3200 50  0000 C CNN
F 2 "Capacitor_SMD:C_0603_1608Metric_Pad1.08x0.95mm_HandSolder" H 3488 3050 50  0001 C CNN
F 3 "~" H 3450 3200 50  0001 C CNN
	1    3450 3200
	0    1    1    0   
$EndComp
$Comp
L Device:C C4
U 1 1 6153DC7B
P 3800 3100
F 0 "C4" V 4050 3050 50  0000 C CNN
F 1 "10nF" V 4150 3100 50  0000 C CNN
F 2 "Capacitor_SMD:C_0603_1608Metric_Pad1.08x0.95mm_HandSolder" H 3838 2950 50  0001 C CNN
F 3 "~" H 3800 3100 50  0001 C CNN
	1    3800 3100
	0    1    1    0   
$EndComp
$Comp
L Device:C C3
U 1 1 6153DC85
P 4150 3000
F 0 "C3" V 4500 3000 50  0000 C CNN
F 1 "22nF" V 4600 3000 50  0000 C CNN
F 2 "Capacitor_SMD:C_0603_1608Metric_Pad1.08x0.95mm_HandSolder" H 4188 2850 50  0001 C CNN
F 3 "~" H 4150 3000 50  0001 C CNN
	1    4150 3000
	0    1    1    0   
$EndComp
$Comp
L Device:C C2
U 1 1 6153DC8F
P 4500 2900
F 0 "C2" V 4950 2900 50  0000 C CNN
F 1 "47nF" V 5050 2900 50  0000 C CNN
F 2 "Capacitor_SMD:C_0603_1608Metric_Pad1.08x0.95mm_HandSolder" H 4538 2750 50  0001 C CNN
F 3 "~" H 4500 2900 50  0001 C CNN
	1    4500 2900
	0    1    1    0   
$EndComp
$Comp
L Device:C C1
U 1 1 6153DC99
P 4850 2800
F 0 "C1" V 5400 2800 50  0000 C CNN
F 1 "100nF" V 5500 2800 50  0000 C CNN
F 2 "Capacitor_SMD:C_0603_1608Metric_Pad1.08x0.95mm_HandSolder" H 4888 2650 50  0001 C CNN
F 3 "~" H 4850 2800 50  0001 C CNN
	1    4850 2800
	0    1    1    0   
$EndComp
$Comp
L Device:C C17
U 1 1 61531496
P 4500 5450
F 0 "C17" V 4950 5450 50  0000 C CNN
F 1 "68pF" V 5050 5450 50  0000 C CNN
F 2 "Capacitor_SMD:C_0603_1608Metric_Pad1.08x0.95mm_HandSolder" H 4538 5300 50  0001 C CNN
F 3 "~" H 4500 5450 50  0001 C CNN
	1    4500 5450
	0    1    1    0   
$EndComp
Wire Wire Line
	3150 5750 3150 5650
Connection ~ 3150 2900
Wire Wire Line
	3150 2900 3150 2800
Connection ~ 3150 3000
Wire Wire Line
	3150 3000 3150 2900
Connection ~ 3150 3100
Wire Wire Line
	3150 3100 3150 3000
Connection ~ 3150 3200
Wire Wire Line
	3150 3200 3150 3100
Connection ~ 3150 3650
Wire Wire Line
	3150 3650 3150 3200
Connection ~ 3150 3750
Wire Wire Line
	3150 3750 3150 3650
Connection ~ 3150 3850
Wire Wire Line
	3150 3850 3150 3750
Connection ~ 3150 3950
Wire Wire Line
	3150 3950 3150 3850
Connection ~ 3150 4050
Wire Wire Line
	3150 4050 3150 3950
Connection ~ 3150 4500
Wire Wire Line
	3150 4500 3150 4050
Connection ~ 3150 4600
Wire Wire Line
	3150 4600 3150 4500
Connection ~ 3150 4700
Wire Wire Line
	3150 4700 3150 4600
Connection ~ 3150 4800
Wire Wire Line
	3150 4800 3150 4700
Connection ~ 3150 4900
Wire Wire Line
	3150 4900 3150 4800
Connection ~ 3150 5350
Wire Wire Line
	3150 5350 3150 4900
Connection ~ 3150 5450
Wire Wire Line
	3150 5450 3150 5350
Connection ~ 3150 5550
Wire Wire Line
	3150 5550 3150 5450
Connection ~ 3150 5650
Wire Wire Line
	3150 5650 3150 5550
Wire Wire Line
	3150 5750 3300 5750
Wire Wire Line
	3150 5650 3650 5650
Wire Wire Line
	3150 5550 4000 5550
Wire Wire Line
	3150 5450 4350 5450
Wire Wire Line
	3150 5350 4700 5350
Wire Wire Line
	3150 4900 3300 4900
Wire Wire Line
	3150 4800 3650 4800
Wire Wire Line
	3150 4700 4000 4700
Wire Wire Line
	3150 4600 4350 4600
Wire Wire Line
	3150 4500 4700 4500
Wire Wire Line
	3150 4050 3300 4050
Wire Wire Line
	3150 3950 3650 3950
Wire Wire Line
	3150 3850 4000 3850
Wire Wire Line
	3150 3750 4350 3750
Wire Wire Line
	3150 3650 4700 3650
Wire Wire Line
	3150 3200 3300 3200
Wire Wire Line
	3150 3100 3650 3100
Wire Wire Line
	3150 3000 4000 3000
Wire Wire Line
	3150 2900 4350 2900
Wire Wire Line
	3150 2800 4700 2800
Wire Wire Line
	5000 2800 5100 2800
Wire Wire Line
	4650 2900 5100 2900
Wire Wire Line
	5100 3000 4300 3000
Wire Wire Line
	3950 3100 5100 3100
Wire Wire Line
	3600 3200 5100 3200
Wire Wire Line
	5000 3650 5100 3650
Wire Wire Line
	4650 3750 5100 3750
Wire Wire Line
	5100 3850 4300 3850
Wire Wire Line
	3950 3950 5100 3950
Wire Wire Line
	3600 4050 5100 4050
Wire Wire Line
	5000 4500 5100 4500
Wire Wire Line
	4650 4600 5100 4600
Wire Wire Line
	5100 4700 4300 4700
Wire Wire Line
	3950 4800 5100 4800
Wire Wire Line
	3600 4900 5100 4900
Wire Wire Line
	5000 5350 5100 5350
Wire Wire Line
	4650 5450 5100 5450
Wire Wire Line
	5100 5550 4300 5550
Wire Wire Line
	3950 5650 5100 5650
Wire Wire Line
	3600 5750 5100 5750
Wire Wire Line
	5700 5350 5800 5350
Wire Wire Line
	5800 5350 5800 5450
Wire Wire Line
	5800 5750 5700 5750
Wire Wire Line
	5700 5650 5800 5650
Connection ~ 5800 5650
Wire Wire Line
	5800 5650 5800 5750
Wire Wire Line
	5800 5550 5700 5550
Connection ~ 5800 5550
Wire Wire Line
	5800 5550 5800 5650
Wire Wire Line
	5700 5450 5800 5450
Connection ~ 5800 5450
Wire Wire Line
	5800 5450 5800 5550
Wire Wire Line
	5700 4500 5800 4500
Wire Wire Line
	5800 4500 5800 4600
Wire Wire Line
	5800 4900 5700 4900
Wire Wire Line
	5700 4800 5800 4800
Connection ~ 5800 4800
Wire Wire Line
	5800 4800 5800 4900
Wire Wire Line
	5800 4700 5700 4700
Connection ~ 5800 4700
Wire Wire Line
	5800 4700 5800 4800
Wire Wire Line
	5700 4600 5800 4600
Connection ~ 5800 4600
Wire Wire Line
	5800 4600 5800 4700
Wire Wire Line
	5700 3650 5800 3650
Wire Wire Line
	5800 3650 5800 3750
Wire Wire Line
	5800 4050 5700 4050
Wire Wire Line
	5700 3950 5800 3950
Connection ~ 5800 3950
Wire Wire Line
	5800 3950 5800 4050
Wire Wire Line
	5800 3850 5700 3850
Connection ~ 5800 3850
Wire Wire Line
	5800 3850 5800 3950
Wire Wire Line
	5700 3750 5800 3750
Connection ~ 5800 3750
Wire Wire Line
	5800 3750 5800 3850
Wire Wire Line
	5700 2800 5800 2800
Wire Wire Line
	5800 2800 5800 2900
Wire Wire Line
	5800 3200 5700 3200
Wire Wire Line
	5700 3100 5800 3100
Connection ~ 5800 3100
Wire Wire Line
	5800 3100 5800 3200
Wire Wire Line
	5800 3000 5700 3000
Connection ~ 5800 3000
Wire Wire Line
	5800 3000 5800 3100
Wire Wire Line
	5700 2900 5800 2900
Connection ~ 5800 2900
Wire Wire Line
	5800 2900 5800 3000
$Comp
L Device:R_POT_TRIM RV1
U 1 1 615B90A4
P 2350 3350
F 0 "RV1" H 2280 3396 50  0000 R CNN
F 1 "1M" H 2280 3305 50  0000 R CNN
F 2 "Potentiometer_THT:Potentiometer_ACP_CA9-V10_Vertical_Hole" H 2350 3350 50  0001 C CNN
F 3 "~" H 2350 3350 50  0001 C CNN
	1    2350 3350
	1    0    0    -1  
$EndComp
$Comp
L Device:R_POT_TRIM RV2
U 1 1 615B99A6
P 2350 3850
F 0 "RV2" H 2280 3896 50  0000 R CNN
F 1 "50k" H 2280 3805 50  0000 R CNN
F 2 "Potentiometer_THT:Potentiometer_ACP_CA9-V10_Vertical_Hole" H 2350 3850 50  0001 C CNN
F 3 "~" H 2350 3850 50  0001 C CNN
	1    2350 3850
	1    0    0    -1  
$EndComp
$Comp
L Device:R_POT_TRIM RV3
U 1 1 615B9C89
P 2350 4300
F 0 "RV3" H 2280 4346 50  0000 R CNN
F 1 "5k" H 2280 4255 50  0000 R CNN
F 2 "Potentiometer_THT:Potentiometer_ACP_CA9-V10_Vertical_Hole" H 2350 4300 50  0001 C CNN
F 3 "~" H 2350 4300 50  0001 C CNN
	1    2350 4300
	1    0    0    -1  
$EndComp
Wire Wire Line
	2350 4450 2350 5750
Wire Wire Line
	2350 5750 3150 5750
Connection ~ 3150 5750
Wire Wire Line
	2350 4000 2350 4150
Wire Wire Line
	2350 3700 2350 3500
$Comp
L Connector:TestPoint TP2
U 1 1 615CE183
P 2350 2350
F 0 "TP2" H 2408 2468 50  0000 L CNN
F 1 "R" H 2408 2377 50  0000 L CNN
F 2 "Connector_Pin:Pin_D1.3mm_L11.0mm" H 2550 2350 50  0001 C CNN
F 3 "~" H 2550 2350 50  0001 C CNN
	1    2350 2350
	1    0    0    -1  
$EndComp
Wire Wire Line
	2350 3200 2350 2350
$Comp
L Connector:TestPoint TP3
U 1 1 615D1602
P 3150 2350
F 0 "TP3" H 3208 2468 50  0000 L CNN
F 1 "COM" H 3208 2377 50  0000 L CNN
F 2 "Connector_Pin:Pin_D1.3mm_L11.0mm" H 3350 2350 50  0001 C CNN
F 3 "~" H 3350 2350 50  0001 C CNN
	1    3150 2350
	1    0    0    -1  
$EndComp
Wire Wire Line
	3150 2800 3150 2350
Connection ~ 3150 2800
$Comp
L Connector:TestPoint TP4
U 1 1 615D7F98
P 5800 2350
F 0 "TP4" H 5858 2468 50  0000 L CNN
F 1 "C" H 5858 2377 50  0000 L CNN
F 2 "Connector_Pin:Pin_D1.3mm_L11.0mm" H 6000 2350 50  0001 C CNN
F 3 "~" H 6000 2350 50  0001 C CNN
	1    5800 2350
	1    0    0    -1  
$EndComp
Wire Wire Line
	5800 2350 5800 2800
Connection ~ 5800 2800
Wire Wire Line
	5800 3200 5800 3650
Connection ~ 5800 3200
Connection ~ 5800 3650
Wire Wire Line
	5800 4500 5800 4050
Connection ~ 5800 4500
Connection ~ 5800 4050
$Comp
L Connector:TestPoint TP1
U 1 1 615E2314
P 1750 2350
F 0 "TP1" H 1808 2468 50  0000 L CNN
F 1 "GND" H 1808 2377 50  0000 L CNN
F 2 "Connector_Pin:Pin_D1.3mm_L11.0mm" H 1950 2350 50  0001 C CNN
F 3 "~" H 1950 2350 50  0001 C CNN
	1    1750 2350
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR01
U 1 1 615E2AEB
P 1750 2350
F 0 "#PWR01" H 1750 2100 50  0001 C CNN
F 1 "GND" H 1755 2177 50  0000 C CNN
F 2 "" H 1750 2350 50  0001 C CNN
F 3 "" H 1750 2350 50  0001 C CNN
	1    1750 2350
	1    0    0    -1  
$EndComp
Wire Wire Line
	5800 4900 5800 5350
Connection ~ 5800 4900
Connection ~ 5800 5350
Wire Wire Line
	2500 3350 2500 3200
Wire Wire Line
	2500 3200 2350 3200
Connection ~ 2350 3200
Wire Wire Line
	2500 3850 2500 3700
Wire Wire Line
	2500 3700 2350 3700
Connection ~ 2350 3700
Wire Wire Line
	2500 4300 2500 4150
Wire Wire Line
	2500 4150 2350 4150
Connection ~ 2350 4150
$EndSCHEMATC
