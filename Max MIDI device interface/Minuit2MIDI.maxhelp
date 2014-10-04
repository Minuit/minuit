{
	"patcher" : 	{
		"fileversion" : 1,
		"appversion" : 		{
			"major" : 6,
			"minor" : 1,
			"revision" : 8,
			"architecture" : "x86"
		}
,
		"rect" : [ 1197.0, 363.0, 625.0, 383.0 ],
		"bglocked" : 0,
		"openinpresentation" : 0,
		"default_fontsize" : 10.0,
		"default_fontface" : 0,
		"default_fontname" : "Arial",
		"gridonopen" : 0,
		"gridsize" : [ 10.0, 10.0 ],
		"gridsnaponopen" : 0,
		"statusbarvisible" : 2,
		"toolbarvisible" : 1,
		"boxanimatetime" : 200,
		"imprint" : 0,
		"enablehscroll" : 1,
		"enablevscroll" : 1,
		"devicewidth" : 0.0,
		"description" : "",
		"digest" : "",
		"tags" : "",
		"boxes" : [ 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 9.0,
					"hidden" : 1,
					"id" : "obj-22",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patcher" : 					{
						"fileversion" : 1,
						"appversion" : 						{
							"major" : 6,
							"minor" : 1,
							"revision" : 8,
							"architecture" : "x86"
						}
,
						"rect" : [ 50.0, 94.0, 411.0, 187.0 ],
						"bglocked" : 0,
						"openinpresentation" : 0,
						"default_fontsize" : 9.0,
						"default_fontface" : 0,
						"default_fontname" : "Arial",
						"gridonopen" : 0,
						"gridsize" : [ 10.0, 10.0 ],
						"gridsnaponopen" : 0,
						"statusbarvisible" : 2,
						"toolbarvisible" : 1,
						"boxanimatetime" : 200,
						"imprint" : 0,
						"enablehscroll" : 1,
						"enablevscroll" : 1,
						"devicewidth" : 0.0,
						"description" : "",
						"digest" : "",
						"tags" : "",
						"boxes" : [ 							{
								"box" : 								{
									"fontname" : "Arial",
									"fontsize" : 9.160198,
									"id" : "obj-46",
									"linecount" : 2,
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 51.0, 129.0, 289.0, 25.0 ],
									"text" : ";\rmax launchbrowser mailto:fxw@wanadoo.fr?subject=fxwMinuit2MIDI"
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-8",
									"maxclass" : "inlet",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 50.0, 40.0, 25.0, 25.0 ]
								}

							}
 ],
						"lines" : [ 							{
								"patchline" : 								{
									"destination" : [ "obj-46", 0 ],
									"disabled" : 0,
									"hidden" : 0,
									"source" : [ "obj-8", 0 ]
								}

							}
 ]
					}
,
					"patching_rect" : [ 550.0, 92.0, 36.0, 17.0 ],
					"saved_object_attributes" : 					{
						"default_fontface" : 0,
						"default_fontname" : "Arial",
						"default_fontsize" : 9.0,
						"description" : "",
						"digest" : "",
						"fontface" : 0,
						"fontname" : "Arial",
						"fontsize" : 9.0,
						"globalpatchername" : "",
						"tags" : ""
					}
,
					"text" : "p sign"
				}

			}
, 			{
				"box" : 				{
					"bgcolor" : [ 1.0, 1.0, 1.0, 0.0 ],
					"bgcolor2" : [ 0.866667, 0.866667, 0.866667, 0.0 ],
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-23",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 548.0, 70.0, 66.0, 18.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 104.0, 304.5, 70.0, 18.0 ],
					"text" : "fxw - 2010",
					"textcolor" : [ 0.168627, 0.176471, 0.368627, 1.0 ]
				}

			}
, 			{
				"box" : 				{
					"bgcolor" : [ 1.0, 1.0, 1.0, 0.0 ],
					"bgcolor2" : [ 0.866667, 0.866667, 0.866667, 0.0 ],
					"fontname" : "Arial",
					"fontsize" : 10.0,
					"id" : "obj-34",
					"ignoreclick" : 1,
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 548.0, 73.0, 67.0, 16.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 104.0, 307.5, 67.0, 16.0 ],
					"text" : "__________",
					"textcolor" : [ 0.168627, 0.176471, 0.368627, 1.0 ]
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 10.0,
					"frgb" : 0.0,
					"id" : "obj-18",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 270.0, 302.0, 214.0, 18.0 ],
					"text" : "message to change Module name argument",
					"textcolor" : [ 0.113725, 0.105882, 0.184314, 1.0 ]
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-15",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 279.0, 317.0, 64.0, 18.0 ],
					"text" : "name toto"
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 10.0,
					"frgb" : 0.0,
					"id" : "obj-17",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 19.0, 193.0, 169.0, 18.0 ],
					"text" : "Must be somewhere in your patch...",
					"textcolor" : [ 0.113725, 0.105882, 0.184314, 1.0 ]
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-2",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 21.0, 217.0, 99.0, 20.0 ],
					"text" : "udpreceive 9998"
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-8",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 21.0, 270.0, 147.0, 20.0 ],
					"text" : "udpsend 127.0.0.1 13579"
				}

			}
, 			{
				"box" : 				{
					"color" : [ 1.0, 0.941176, 0.0, 1.0 ],
					"fontname" : "Arial",
					"fontsize" : 10.0,
					"id" : "obj-1",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 21.0, 244.0, 69.0, 18.0 ],
					"text" : "fxw_interface"
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 24.0,
					"frgb" : 0.0,
					"id" : "obj-12",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 242.0, 184.0, 99.0, 33.0 ],
					"text" : "MIDI ctrl",
					"textcolor" : [ 0.113725, 0.105882, 0.184314, 1.0 ]
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 10.0,
					"frgb" : 0.0,
					"id" : "obj-11",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 240.0, 132.0, 140.0, 18.0 ],
					"text" : "MIDI devices (input & output)"
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 10.0,
					"frgb" : 0.0,
					"id" : "obj-10",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 431.0, 327.0, 124.0, 18.0 ],
					"text" : "ctrl n° 6,7,8 on MIDI ch 4"
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 10.0,
					"frgb" : 0.0,
					"id" : "obj-7",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 439.0, 263.0, 146.0, 18.0 ],
					"text" : "ctrl n° 65 and 66 on MIDI ch 2"
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 10.0,
					"frgb" : 0.0,
					"id" : "obj-6",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 246.0, 226.0, 315.0, 18.0 ],
					"text" : "2 attributes : @offset = ctrl number offset, @MIDIch = MIDI channel ",
					"textcolor" : [ 0.113725, 0.105882, 0.184314, 1.0 ]
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 10.0,
					"frgb" : 0.0,
					"id" : "obj-4",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 245.0, 211.0, 363.0, 18.0 ],
					"text" : "2 arguments : 1° = Module name, 2° = Number of MIDI ctrl ",
					"textcolor" : [ 0.113725, 0.105882, 0.184314, 1.0 ]
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 24.0,
					"frgb" : 0.0,
					"id" : "obj-3",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 12.0, 8.0, 171.0, 33.0 ],
					"text" : "Minuit to MIDI",
					"textcolor" : [ 0.827451, 0.831373, 0.858824, 1.0 ]
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 10.0,
					"id" : "obj-14",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 161.0, 100.0, 62.0, 18.0 ],
					"text" : "loadmess 0"
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 11.595187,
					"id" : "obj-19",
					"items" : [ "to Max 1", ",", "to Max 2" ],
					"maxclass" : "umenu",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "int", "", "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 135.0, 148.0, 180.0, 19.0 ]
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Arial",
					"fontsize" : 10.0,
					"id" : "obj-13",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 135.0, 124.0, 45.0, 18.0 ],
					"text" : "midiinfo"
				}

			}
, 			{
				"box" : 				{
					"color" : [ 1.0, 0.941176, 0.0, 1.0 ],
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-9",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 251.0, 343.0, 265.0, 20.0 ],
					"text" : "fxwMinuit2ctrl moduleB 3 @offset 5 @MIDIch 4"
				}

			}
, 			{
				"box" : 				{
					"color" : [ 1.0, 0.941176, 0.0, 1.0 ],
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-29",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 272.0, 279.0, 271.0, 20.0 ],
					"text" : "fxwMinuit2ctrl moduleA 2 @offset 64 @MIDIch 2"
				}

			}
, 			{
				"box" : 				{
					"background" : 1,
					"bgcolor" : [ 0.827451, 0.827451, 0.827451, 1.0 ],
					"grad1" : [ 0.27, 0.35, 0.47, 1.0 ],
					"grad2" : [ 0.85, 0.85, 0.85, 1.0 ],
					"id" : "obj-5",
					"maxclass" : "panel",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 241.0, 181.0, 377.0, 197.0 ],
					"varname" : "autohelp_top_panel[1]"
				}

			}
, 			{
				"box" : 				{
					"background" : 1,
					"grad1" : [ 0.27, 0.35, 0.47, 1.0 ],
					"grad2" : [ 0.85, 0.85, 0.85, 1.0 ],
					"id" : "obj-20",
					"maxclass" : "panel",
					"mode" : 1,
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 5.0, 5.0, 615.0, 86.0 ],
					"varname" : "autohelp_top_panel"
				}

			}
, 			{
				"box" : 				{
					"background" : 1,
					"bgcolor" : [ 0.827451, 0.827451, 0.827451, 1.0 ],
					"grad1" : [ 0.27, 0.35, 0.47, 1.0 ],
					"grad2" : [ 0.85, 0.85, 0.85, 1.0 ],
					"id" : "obj-16",
					"maxclass" : "panel",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 15.0, 182.0, 184.0, 125.0 ],
					"varname" : "autohelp_top_panel[3]"
				}

			}
 ],
		"lines" : [ 			{
				"patchline" : 				{
					"destination" : [ "obj-8", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-1", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-19", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-13", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-13", 1 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-14", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-9", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-15", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-29", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"midpoints" : [ 225.0, 269.5, 281.5, 269.5 ],
					"source" : [ "obj-19", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-9", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"midpoints" : [ 225.0, 334.5, 260.5, 334.5 ],
					"source" : [ "obj-19", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-1", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-2", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-22", 0 ],
					"disabled" : 0,
					"hidden" : 1,
					"source" : [ "obj-23", 0 ]
				}

			}
 ],
		"dependency_cache" : [ 			{
				"name" : "fxwMinuit2ctrl.maxpat",
				"bootpath" : "/Users/bltzr/dev/Minuit/Max MIDI device interface",
				"patcherrelativepath" : ".",
				"type" : "JSON",
				"implicit" : 1
			}
, 			{
				"name" : "fxw_interface.maxpat",
				"bootpath" : "/Users/bltzr/dev/Minuit/Max MIDI device interface",
				"patcherrelativepath" : ".",
				"type" : "JSON",
				"implicit" : 1
			}
, 			{
				"name" : "OSC-route.mxo",
				"type" : "iLaX"
			}
 ]
	}

}
