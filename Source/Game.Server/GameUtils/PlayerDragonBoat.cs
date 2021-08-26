using Game.Server.GameObjects;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using SqlDataProvider.Data;
using Bussiness;
using Game.Server.Managers;
using Game.Base.Packets;
using Game.Server.ChatServer;

namespace Game.Server.GameUtils
{
    public class PlayerDragonBoat
    {
        protected UserDragonBoat m_dragon;
        public UserDragonBoat DragonInfo
        {
            get { return m_dragon; }
            set { m_dragon = value; }
        }
        protected GamePlayer m_player;
        public GamePlayer Player
        {
            get { return m_player; }
            set { m_player = value; }
        }
        private bool savetoDb;
        public PlayerDragonBoat(GamePlayer player, bool saveToDb)
        {
            m_player = player;
            savetoDb = saveToDb;
            m_dragon = new UserDragonBoat();
        }
        public void SendAddDragonChat()
        {
            GSPacketIn pkg = new GSPacketIn((int)eChatServerPacket.DRAGONCHAT);
            pkg.WriteByte((byte)eChatDragonBoat.ADD_USER);
            pkg.WriteInt(m_dragon.UserID);
            pkg.WriteString(m_dragon.NickName);
            pkg.WriteInt(m_dragon.Exp);
            pkg.WriteInt(m_dragon.Point);
            pkg.WriteInt(m_dragon.TotalPoint);
            GameServer.Instance.LoginServer.SendPacket(pkg);
        }
        public virtual void LoadFromDatabase()
        {
            if (savetoDb)
            {
                using (DragonBoatBussiness pb = new DragonBoatBussiness())
                {
                    try
                    {
                        List<UserDragonBoat> lists = null;
                        // lay du lieu tu db bo vao list
                        m_dragon = pb.GetSingleDragonBoat(Player.PlayerCharacter.ID);
                        // khong ton tai thi tao moi
                        if (m_dragon == null)
                            CreateDragonBoat();
                        else
                            SendAddDragonChat();
                    }
                    finally
                    {
                    }
                }
            }
        }

        // khoi tao thuyen rong
        public void CreateDragonBoat()
        {
            if (m_dragon == null)
            {
                m_dragon = new UserDragonBoat();
            }
            lock (m_dragon)
            {
                m_dragon.NickName = Player.PlayerCharacter.NickName;
                m_dragon.UserID = Player.PlayerCharacter.ID;
                m_dragon.Exp = 0;
                m_dragon.Point = 0;
                m_dragon.TotalPoint = 0;
                m_dragon.LessPoint = 0;
                m_dragon.Rank = 0;
                using (DragonBoatBussiness db = new DragonBoatBussiness())
                {
                    if (m_dragon != null && m_dragon.IsDirty == true)
                    {
                        db.AddDragonBoat(m_dragon);
                    }
                }
            }
        }
        public virtual void SaveToDb()
        {
            if (savetoDb)
            {
                using (DragonBoatBussiness pb = new DragonBoatBussiness())
                {
                    lock (m_dragon)
                    {
                        // check nick name
                        if (m_dragon.NickName != Player.PlayerCharacter.NickName)
                        {
                            m_dragon.NickName = Player.PlayerCharacter.NickName;
                        }
                        if (m_dragon != null && m_dragon.IsDirty)
                        {
                            pb.UpdateDragonBoat(m_dragon);
                            // update to mgr
                            //SendAddDragonChat();
                        }
                    }
                }
            }
        }
    }
}