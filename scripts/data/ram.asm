


RAM.High = 						10240
RAM.HighHundredThousands = 		10241
RAM.HighTenThousands = 			10242
RAM.HighThousands = 			10243
RAM.HighHundreds =    			10244
RAM.HighTens = 					10245
RAM.HighDigits =       			10246

RAM.ScoreCounter = 				10247
RAM.Row = 						10248
RAM.Column = 					10249
RAM.Amount = 					10250
RAM.X =							10251
RAM.Y = 						10252
RAM.Seed =						10253  
RAM.CurrentID =         		10254

RAM.ControlDebounce1 =   		10255
RAM.ControlDebounce2 =  		10256

RAM.Score = 					10257
RAM.ScoreHundredThousands = 	10258
RAM.ScoreTenThousands = 		10259
RAM.ScoreThousands = 			10260
RAM.ScoreHundreds =    			10261
RAM.ScoreTens = 				10262
RAM.ScoreDigits =       		10263
RAM.TenThousandPrevious = 		10264

RAM.StartX = 					10265
RAM.StartY = 					10266
RAM.EndX = 						10267
RAM.EndY = 						10268
RAM.XReg = 						10269
RAM.YReg = 						10270
RAM.Direction = 				10271
RAM.CurrentColumn = 			10272
RAM.EndColumn = 				10273
RAM.MoveMade =					10274

RAM.ScoreToAdd = 				10275
RAM.ScoreAddHundredThousands = 	10276
RAM.ScoreAddTenThousands = 		10277
RAM.ScoreAddThousands = 		10278
RAM.ScoreAddHundreds =    		10279
RAM.ScoreAddTens = 				10280
RAM.ScoreAddDigits =       		10281
RAM.ScoreThisRound =			10282
RAM.ScoreCooldown = 			10283

RAM.ShipX =						10284
RAM.ShipY =						10285
RAM.ShipStatus = 				10286
RAM.ShipCooldown = 				10287
RAM.ShipDeadChar = 				10288

RAM.BulletX =					10289
RAM.BulletY =  					10290
RAM.BulletMoved =     			10291
RAM.BulletCooldown = 			10292


RAM.JoyDownNow	= 				10319
RAM.JoyDownLast =				10320
RAM.JoyUpNow = 					10321
RAM.JoyUpLast = 				10322
RAM.JoyRightNow =				10323
RAM.JoyRightLast =				10324
RAM.JoyLeftNow =				10325
RAM.JoyLeftLast =				10326
RAM.JoyFireNow = 				10327
RAM.JoyFireLast = 				10328
RAM.FireUpThisFrame = 			10329


RAM.ScorpionCooldown = 			10330
RAM.ScorpionX = 				10331
RAM.ScorpionY = 				10332
RAM.ScorpionSFX =				10333
RAM.ScorpionNote = 				10334
RAM.ScorpionEnd = 				10335
RAM.ScorpionDirection = 		10336


RAM.SpawnPod = 					10357
RAM.SpawnDelay = 				10358

RAM.SpiderX = 					10360
RAM.SpiderY = 					10361
RAM.SpiderSideAim = 			10362
RAM.SpiderXSpeed = 				10363
RAM.SpiderYSpeed = 				10364
RAM.SpiderCooldown =	 		10365
RAM.SpiderSoundID = 			10366


RAM.Lives = 					10367
RAM.DrawLives = 				10368
RAM.PlayerPodCount = 			10369

RAM.DeathTimer = 				10370
RAM.DeathSFX = 					10371
RAM.DeathSFX2 = 				10372
RAM.DeathSFX3 = 				10373

RAM.FleaCooldown = 				10374
RAM.FleaX = 					10375
RAM.FleaY = 					10376
RAM.FleaSpeed = 				10377
RAM.FleaPodID = 				10378
RAM.FleaSFX = 					10379
RAM.FleaNote = 					10380
RAM.FleaEnd = 					10381

RAM.CentSpawners = 				10388
RAM.HeadDirection = 			10389
RAM.HeadsInLevel = 				10390
RAM.HeadsLeft = 				10391

RAM.CentCooldown = 				10392
RAM.CentProcessID = 			10394
RAM.SpawnReady = 				10395
RAM.LastSpawned = 				10396
RAM.LastOfCent = 				10397
RAM.CentsAlive = 				10398
RAM.Level = 					10399


RAM.Grid = 				10400 + GRID_COLUMNS * 0
RAM.Grid_Row1	=		10400 + GRID_COLUMNS * 1
RAM.Grid_Row2	=		10400 + GRID_COLUMNS * 2
RAM.Grid_Row3	=		10400 + GRID_COLUMNS * 3
RAM.Grid_Row4	=		10400 + GRID_COLUMNS * 4
RAM.Grid_Row5	=		10400 + GRID_COLUMNS * 5
RAM.Grid_Row6	=		10400 + GRID_COLUMNS * 6
RAM.Grid_Row7	=		10400 + GRID_COLUMNS * 7
RAM.Grid_Row8	=		10400 + GRID_COLUMNS * 8
RAM.Grid_Row9	=		10400 + GRID_COLUMNS * 9
RAM.Grid_Row10	=		10400 + GRID_COLUMNS * 10
RAM.Grid_Row11	=		10400 + GRID_COLUMNS * 11
RAM.Grid_Row12	=		10400 + GRID_COLUMNS * 12
RAM.Grid_Row13	=		10400 + GRID_COLUMNS * 13
RAM.Grid_Row14	=		10400 + GRID_COLUMNS * 14
RAM.Grid_Row15	=		10400 + GRID_COLUMNS * 15
RAM.Grid_Row16	=		10400 + GRID_COLUMNS * 16
RAM.Grid_Row17	=		10400 + GRID_COLUMNS * 17
RAM.Grid_Row18	=		10400 + GRID_COLUMNS * 18

RAM.PodX = 						10400 + GRID_COLUMNS * 19
RAM.PodY = 						RAM.PodX + MAX_PODS
RAM.PodStatus =					RAM.PodY + MAX_PODS

RAM.CentX = 					RAM.PodStatus + MAX_PODS
RAM.CentY = 					RAM.CentX + MAX_CENTS
RAM.CentStatus = 				RAM.CentY + MAX_CENTS
RAM.CentPlunge = 				RAM.CentStatus + MAX_CENTS
RAM.CentInFront = 				RAM.CentPlunge  +MAX_CENTS
