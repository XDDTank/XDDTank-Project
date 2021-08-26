﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Managers;
using Bussiness;
using Game.Server.Rooms;
using Game.Logic;
using Game.Server.Statics;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.GAME_ROOM, "游戏创建")]
    public class GameRoomHandler : IPacketHandler
    {      
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            var game_room = packet.ReadInt();
            Console.WriteLine("??????????????GameRoomHandler: " + (GameRoomPackageType)game_room);
            switch (game_room)
            {
                case (int)GameRoomPackageType.GAME_ROOM_SETUP_CHANGE:
                    {
                        if (client.Player.CurrentRoom != null && client.Player == client.Player.CurrentRoom.Host && !client.Player.CurrentRoom.IsPlaying)
                        {
                            int mapId = packet.ReadInt();//this._view.selectedMapID
                            eRoomType roomType = (eRoomType)packet.ReadByte();
                            bool isOpenBoss = packet.ReadBoolean();//_loc_12.isOpenBoss.writeBoolean(param3);
                            string roomPass = packet.ReadString();//_current.roomPass = event.pkg.readUTF();
                            string roomName = packet.ReadString();//_current.roomName = event.pkg.readUTF();  
                            byte timeType = packet.ReadByte();
                            byte hardLevel = packet.ReadByte();
                            int levelLimits = packet.ReadInt();
                            bool isCrossZone = packet.ReadBoolean();//_current.isCrossZone = event.pkg.readBoolean();
                            int mapId2 = packet.ReadInt();
                            Console.WriteLine("?????????MapID: " + mapId.ToString() + " |roomType: " + roomType.ToString());

                            //RoomMgr.UpdateRoomGameType(client.Player.CurrentRoom,
                            //    roomType, timeType, (eHardLevel)hardLevel, levelLimits, 
                            //    mapId, roomPass, roomName, isCrossZone, isOpenBoss);    
                            client.Out.SendMessage(eMessageType.Normal, "Chức năng đang xây dựng");
                        }                        
                        break;
                    }
                case (int)GameRoomPackageType.GAME_ROOM_REMOVEPLAYER:
                    {
                        if (client.Player.CurrentRoom != null)
                        {
                            RoomMgr.ExitRoom(client.Player.CurrentRoom, client.Player);
                        }
                        //RoomMgr.ExitWaitingRoom(client.Player);                        
                        break;
                    }
                case (int)GameRoomPackageType.GAME_ROOM_UPDATE_PLACE:
                    {
                        if (client.Player.CurrentRoom != null && client.Player == client.Player.CurrentRoom.Host)
                        {
                            byte playerPlace = packet.ReadByte();
                            int place = packet.ReadInt();
                            bool isOpen = packet.ReadBoolean();
                            int placeView = packet.ReadInt();
                            
                            RoomMgr.UpdateRoomPos(client.Player.CurrentRoom, playerPlace, isOpen, place, placeView);
                        }
                        break;
                    }
                    
                case (int)GameRoomPackageType.GAME_PICKUP_CANCEL:
                    {
                        // GAME_AWIT_CANCEL                        
                        if (client.Player.CurrentRoom != null && client.Player.CurrentRoom.BattleServer != null)
                        {
                            client.Player.CurrentRoom.BattleServer.RemoveRoom(client.Player.CurrentRoom);
                            if (client.Player != client.Player.CurrentRoom.Host)
                            {
                                client.Player.CurrentRoom.Host.Out.SendMessage(eMessageType.ChatERROR, LanguageMgr.GetTranslation("Game.Server.SceneGames.PairUp.Failed"));
                                RoomMgr.UpdatePlayerState(client.Player, 0);
                            }
                            else
                            {
                                RoomMgr.UpdatePlayerState(client.Player, 2);
                            }
                        }

                        break;
                    }
                case (int)GameRoomPackageType.GAME_PICKUP_STYLE:
                    {                       
                        //_loc_2.writeInt(param1); 2 opton sendGameStyle and sendGameMode
                        //GMAE_STYLE_RECV FREE_MODE:int = 0; GUILD_MODE:int = 1;
                        int game = packet.ReadInt();
                        if (client.Player.CurrentRoom != null)
                        {
                            int GameStyle = packet.ReadInt();
                            switch (GameStyle)
                            {
                                case 0:
                                    client.Player.CurrentRoom.GameType = eGameType.Free;
                                    break;
                                default:
                                    client.Player.CurrentRoom.GameType = eGameType.Guild;
                                    break;
                            }
                            GSPacketIn pkg = client.Player.Out.SendRoomType(client.Player, client.Player.CurrentRoom);
                            client.Player.CurrentRoom.SendToAll(pkg, client.Player);
                        }
                      
                        break;
                    }                
                
                case (int)GameRoomPackageType.GAME_PLAYER_STATE_CHANGE:
                    {
                        if (client.Player.MainWeapon == null)
                        {
                            client.Player.SendMessage(LanguageMgr.GetTranslation("Game.Server.SceneGames.NoEquip"));
                            return 0;
                        }
                        if (client.Player.CurrentRoom != null)
                        {
                            RoomMgr.UpdatePlayerState(client.Player, packet.ReadByte());
                        }
                        break;
                    }
                
                case (int)GameRoomPackageType.GAME_ROOM_CREATE:
                    {
                        byte roomType = packet.ReadByte();
                        byte timeType = packet.ReadByte();
                        string roomName = packet.ReadString();
                        string pwd = packet.ReadString();
                      

                        RoomMgr.CreateRoom(client.Player, roomName, pwd, (eRoomType)roomType, timeType);
                        break;
                    }
                case (int)GameRoomPackageType.GAME_ROOM_KICK:
                    {
                        //_loc_2.writeByte(param1);
                        if (client.Player.CurrentRoom != null && client.Player == client.Player.CurrentRoom.Host)
                        {
                            RoomMgr.KickPlayer(client.Player.CurrentRoom, packet.ReadByte());
                        }
                        break;
                    }
                case (int)GameRoomPackageType.GAME_ROOM_LOGIN:
                    {
                        bool isInvite = packet.ReadBoolean();
                        int type = packet.ReadInt();
                        int isRoundID = packet.ReadInt();
                        int roomId = -1;
                        string pwd = null;

                        if (isRoundID == -1)
                        {
                            roomId = packet.ReadInt();
                            pwd = packet.ReadString();
                        }
                        if (type == 1) type = 0;
                        else if (type == 2) type = 4;
                        RoomMgr.EnterRoom(client.Player, roomId, pwd, type);

                        break;
                    }
                case (int)GameRoomPackageType.GAME_START:
                    {                        
                        BaseRoom room = client.Player.CurrentRoom;
                        if (room != null && room.Host == client.Player)
                        {
                            if (room.RoomType == eRoomType.Dungeon)
                            {
                                if (!client.Player.IsPvePermission(room.MapId, room.HardLevel))
                                {
                                    //TODO 写入语言包中，以便多语言转换
                                    client.Player.SendMessage("Không đủ quyền hạn !");
                                    return 0;
                                }
                            }
                            //RoomMgr.StartGame(client.Player.CurrentRoom);  
                            client.Out.SendMessage(eMessageType.Normal, "Chức năng đang xây dựng");
                        }
                        break;
                    }
                case (int)GameRoomPackageType.GAME_TEAM:
                    {
                        //_loc_2.writeByte(param1);
                        if (client.Player.CurrentRoom == null || client.Player.CurrentRoom.RoomType == eRoomType.Match)
                            return 0;

                        RoomMgr.SwitchTeam(client.Player);
                        break;
                    }

                case (int)GameRoomPackageType.ROOMLIST_UPDATE:
                    {
                        int hallType = packet.ReadInt();
                        int updateType = packet.ReadInt();
                        int pveMapRoom = 10000;
                        int pveHardLevel = 1011;
                        if (updateType == -2)
                        {
                            pveMapRoom = packet.ReadInt();
                            pveHardLevel = packet.ReadInt();
                        }

                        BaseRoom[] list = RoomMgr.Rooms;
                        List<BaseRoom> tempList = new List<BaseRoom>();

                        for (int i = 0; i < list.Length; i++)
                        {
                            if (!list[i].IsEmpty)
                            {
                                switch (updateType)
                                {
                                    case 3:
                                        if (list[i].RoomType == eRoomType.Match || list[i].RoomType == eRoomType.Freedom)
                                        {
                                            tempList.Add(list[i]);
                                        }
                                        break;
                                    case 4:
                                        if (list[i].RoomType == eRoomType.Match)
                                        {
                                            tempList.Add(list[i]);
                                        }
                                        break;
                                    case 5:
                                        if (list[i].RoomType == eRoomType.Freedom)
                                        {
                                            tempList.Add(list[i]);
                                        }
                                        break;
                                    default:
                                        if (list[i].RoomType == eRoomType.Dungeon)
                                        {
                                            switch (pveHardLevel)
                                            {
                                                case 1007:
                                                    if (list[i].HardLevel == eHardLevel.Simple)
                                                    {
                                                        tempList.Add(list[i]);
                                                    }
                                                    break;
                                                case 1008:
                                                    if (list[i].HardLevel == eHardLevel.Normal)
                                                    {
                                                        tempList.Add(list[i]);
                                                    }
                                                    break;
                                                case 1009:
                                                    if (list[i].HardLevel == eHardLevel.Hard)
                                                    {
                                                        tempList.Add(list[i]);
                                                    }
                                                    break;
                                                case 1010:
                                                    if (list[i].HardLevel == eHardLevel.Terror)
                                                    {
                                                        tempList.Add(list[i]);
                                                    }
                                                    break;
                                                default:
                                                    tempList.Add(list[i]);
                                                    break;
                                            }
                                        }
                                        break;
                                }
                            }
                        }
                        if (tempList.Count > 0) 
                        client.Out.SendUpdateRoomList(tempList);
                        break;
                    }
            }

            return 0;
        }
    }
}
