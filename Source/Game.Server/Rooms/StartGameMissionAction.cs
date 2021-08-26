using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Server.GameObjects;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.Games;
using Game.Server.Battle;
using Game.Server.Packets;
using Game.Logic.Phy.Object;

namespace Game.Server.Rooms
{
    public class StartGameMissionAction : IAction
    {
        BaseRoom m_room;

        public StartGameMissionAction(BaseRoom room)
        {
            m_room = room;
        }

        public void Execute()
        {
            if (m_room.BaseGames.GameState == eGameState.SessionPrepared || m_room.BaseGames.GameState == eGameState.GameOver)
            {
                foreach (Player p in m_room.BaseGames.Players.Values)
                {
                    if (p is Player)
                    {
                        p.Ready = true;
                    }
                }
                m_room.BaseGames.CheckState(0);
                GSPacketIn pkg = m_room.Host.Out.SendGameMissionStart();
                m_room.SendToAll(pkg, m_room.Host);

            }
        }
    }
}
