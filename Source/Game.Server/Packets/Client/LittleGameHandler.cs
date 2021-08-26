using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;
using Game.Base.Packets;
//using Game.Server.Managers;
using Game.Server.GameObjects;
//using Game.Server.GameUtils;
//using Game.Server.Rooms;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.LITTLEGAME_COMMAND, "场景用户离开")]
    public class LittleGameHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            var LittleGame_cmd = packet.ReadByte();
            switch (LittleGame_cmd)
            {
                case (int)LittleGamePackageOut.ADD_OBJECT:
                    {
                        Console.WriteLine("//ADD_OBJECT ");
                        break;
                    }
                case (int)LittleGamePackageOut.ADD_SPRITE:
                    {
                        Console.WriteLine("//ADD_SPRITE ");
                        break;
                    }
                case (int)LittleGamePackageOut.DoAction:
                    {
                        Console.WriteLine("//DoAction ");
                        break;
                    }
                case (int)LittleGamePackageOut.DoMovie:
                    {
                        Console.WriteLine("//DoMovie ");
                        break;
                    }
                case (int)LittleGamePackageOut.GAME_START:
                    {
                        Console.WriteLine("//GAME_START ");
                        break;
                    }
                case (int)LittleGamePackageOut.GETSCORE:
                    {
                        Console.WriteLine("//GETSCORE ");
                        break;
                    }
                case (int)LittleGamePackageOut.INVOKE_OBJECT:
                    {
                        Console.WriteLine("//INVOKE_OBJECT ");
                        break;
                    }
                case (int)LittleGamePackageOut.KICK_PLAYE:
                    {
                        Console.WriteLine("//KICK_PLAYE ");
                        break;
                    }
                case (int)LittleGamePackageOut.MOVE:
                    {
                        Console.WriteLine("//MOVE ");
                        break;
                    }
                case (int)LittleGamePackageOut.NET_DELAY:
                    {
                        Console.WriteLine("//NET_DELA ");
                        break;
                    }
                case (int)LittleGamePackageOut.PONG:
                    {
                        Console.WriteLine("//PONG ");
                        break;
                    }
                case (int)LittleGamePackageOut.REMOVE_OBJECT:
                    {
                        Console.WriteLine("//REMOVE_OBJECT ");
                        break;
                    }
                case (int)LittleGamePackageOut.REMOVE_SPRITE:
                    {
                        Console.WriteLine("//REMOVE_SPRITE ");
                        break;
                    }
                case (int)LittleGamePackageOut.SETCLOCK:
                    {
                        Console.WriteLine("//SETCLOCK ");
                        break;
                    }
                default:
                    Console.WriteLine("//worldBoss_cmd: " + LittleGame_cmd);
                    break;
            }
            return 0;
        }
    }
}
