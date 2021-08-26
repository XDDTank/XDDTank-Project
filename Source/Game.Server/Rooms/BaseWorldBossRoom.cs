using System;
using System.Collections.Generic;
using System.Linq;
using Game.Server.GameObjects;
using System.Threading;
using Game.Base.Packets;
using Game.Server.Packets;

namespace Game.Server.Rooms
{
    public class BaseWorldBossRoom
    {
        //tạo các field cho class
        object m_lock = new object();
        Dictionary<int, GamePlayer> m_list;//list chứa các player trong world boss room
        bool m_die;
        //các property
        private bool IsDie
        {
            get { return m_die; }
            set { m_die = value; }
        }
        //tạo constructor
        public BaseWorldBossRoom()
        {
            m_list = new Dictionary<int,GamePlayer>();
            this.IsDie = false;//giả sử boss còn sống
        }
        //hàm thêm player vào room
        public bool AddPlayer(GamePlayer player)
        {
            bool flag = false;
            Dictionary<int, GamePlayer> list;
            Monitor.Enter(list = this.m_list);
            try
            {
                if (!this.m_list.ContainsKey(player.PlayerId))
                {
                    flag = true;
                    this.m_list.Add(player.PlayerId, player);
                    SendAddPlayer(player);
                }
            }
            finally
            {
                Monitor.Exit(list);
            }
            return flag;
        }
        public void SendAddPlayer(GamePlayer player)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.WORLDBOSS_CMD);
            pkg.WriteByte(3);
            pkg.WriteInt(player.PlayerCharacter.Grade);//_loc_3.Grade = _loc_2.readInt();
            pkg.WriteInt(player.PlayerCharacter.Hide);//_loc_3.Hide = _loc_2.readInt();
            pkg.WriteInt(player.PlayerCharacter.Repute);//_loc_3.Repute = _loc_2.readInt();
            pkg.WriteInt(player.PlayerId);//_loc_3.ID = _loc_2.readInt();
            pkg.WriteString(player.PlayerCharacter.NickName);//_loc_3.NickName = _loc_2.readUTF();
            pkg.WriteByte(player.PlayerCharacter.typeVIP);//_loc_3.typeVIP = _loc_2.readByte();
            pkg.WriteInt(player.PlayerCharacter.VIPLevel);//_loc_3.VIPLevel = _loc_2.readInt();
            pkg.WriteBoolean(player.PlayerCharacter.Sex);//_loc_3.Sex = _loc_2.readBoolean();
            pkg.WriteString(player.PlayerCharacter.Style);//_loc_3.Style = _loc_2.readUTF();
            pkg.WriteString(player.PlayerCharacter.Colors);//_loc_3.Colors = _loc_2.readUTF();
            pkg.WriteString(player.PlayerCharacter.Skin);//_loc_3.Skin = _loc_2.readUTF();
            pkg.WriteInt(123);//_loc_4 = _loc_2.readInt();
            pkg.WriteInt(456);//_loc_5 = _loc_2.readInt();
            pkg.WriteInt(player.PlayerCharacter.FightPower);//_loc_3.FightPower = _loc_2.readInt();
            pkg.WriteInt(player.PlayerCharacter.Win);//_loc_3.WinCount = _loc_2.readInt();
            pkg.WriteInt(player.PlayerCharacter.Total);//_loc_3.TotalCount = _loc_2.readInt();
            pkg.WriteInt(player.PlayerCharacter.Offer);//_loc_3.Offer = _loc_2.readInt();
            pkg.WriteByte(1);//_loc_6.playerStauts = _loc_2.readByte();
            player.SendTCP(pkg);
        }
        //hàm remove player
        public void RemovePlayer(GamePlayer player)
        {
            Dictionary<int, GamePlayer> list;
            Monitor.Enter(list = this.m_list);
            try
            {
                if (this.m_list.ContainsKey(player.PlayerId))
                {
                    this.m_list.Remove(player.PlayerId);
                    player.Out.SendSceneRemovePlayer(player);
                }
            }
            finally
            {
                Monitor.Exit(list);
            }
        }
        //hàm update player
        public void UpdatePlayer(GamePlayer player)
        {
            GamePlayer[] players = this.GetAllPlayerInRoom();
            int i;
            for (i = 0; i < players.Length; i++)
            {
                GamePlayer gamePlayer = players[i];
                GSPacketIn gSPacketIn = new GSPacketIn(102);
                gSPacketIn.WriteByte(3);
                gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Grade);
                gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Hide);
                gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Repute);
                gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.ID);
                gSPacketIn.WriteString(gamePlayer.PlayerCharacter.NickName);
                gSPacketIn.WriteByte(gamePlayer.PlayerCharacter.typeVIP);
                gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.VIPLevel);
                gSPacketIn.WriteBoolean(gamePlayer.PlayerCharacter.Sex);
                gSPacketIn.WriteString(gamePlayer.PlayerCharacter.Style);
                gSPacketIn.WriteString(gamePlayer.PlayerCharacter.Colors);
                gSPacketIn.WriteString(gamePlayer.PlayerCharacter.Skin);
                gSPacketIn.WriteInt(123);
                gSPacketIn.WriteInt(456);
                gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.FightPower);
                gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Win);
                gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Total);
                gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Offer);
                gSPacketIn.WriteByte(1);
                player.SendTCP(gSPacketIn);
            }
        }
        //hàm lấy player trong room
        public GamePlayer[] GetAllPlayerInRoom()
        {
            GamePlayer[] array = null;
            Monitor.Enter(m_lock);
            try
            {
                array = new GamePlayer[this.m_list.Count];
                this.m_list.Values.CopyTo(array, 0);
            }
            finally
            {
                Monitor.Exit(m_lock);
            }
            return array;
        }
    }
}
