using System;
using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Reflection;
using System.Threading;
using Game.Base.Packets;
using Game.Logic.Actions;
using Game.Logic.Phy.Maps;
using Game.Logic.Phy.Object;
using log4net;
using SqlDataProvider.Data;

namespace Game.Logic
{
    public class BaseGame : AbstractGame
    {
        public delegate void GameOverLogEventHandle(int roomId, eRoomType roomType, eGameType fightType, int changeTeam, DateTime playBegin, DateTime playEnd, int userCount, int mapId, string teamA, string teamB, string playResult, int winTeam, string BossWar);

        public delegate void GameNpcDieEventHandle(int NpcId);

        public static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        protected int turnIndex;
        protected int m_nextWind;
        protected eGameState m_gameState;
        protected Map m_map;
        protected Dictionary<int, Player> m_players;
        protected List<Living> m_livings;
        protected Random m_random;
        protected TurnedLiving m_currentLiving;
        public int PhysicalId;
        public int CurrentTurnTotalDamage;
        public int TotalHurt;
        public int ConsortiaAlly;
        public int RichesRate;
        public string BossWarField;
        private ArrayList m_actions;
        private List<TurnedLiving> m_turnQueue;
        private int m_roomId;
        public int[] Cards;
        private int m_lifeTime = 0;
        private long m_waitTimer = 0L;
        private long m_passTick = 0L;
        public int CurrentActionCount = 0;
        private List<Box> m_tempBox;
        private List<Point> m_tempPoints;
        private List<LoadingFileInfo> m_loadingFiles = new List<LoadingFileInfo>();
        private List<PetSkillElementInfo> GameNeedPetSkillInfo = new List<PetSkillElementInfo>();
        public int TotalCostMoney;
        public int TotalCostGold;

        public event GameEventHandle GameOverred;

        public event GameEventHandle BeginNewTurn;

        public event BaseGame.GameOverLogEventHandle GameOverLog;

        public event BaseGame.GameNpcDieEventHandle GameNpcDie;

        protected int m_turnIndex
        {
            get
            {
                return this.turnIndex;
            }
            set
            {
                this.turnIndex = value;
            }
        }

        public int RoomId
        {
            get
            {
                return this.m_roomId;
            }
        }

        public Dictionary<int, Player> Players
        {
            get
            {
                return this.m_players;
            }
        }

        public int PlayerCount
        {
            get
            {
                Dictionary<int, Player> players;
                Monitor.Enter(players = this.m_players);
                int count;
                try
                {
                    count = this.m_players.Count;
                }
                finally
                {
                    Monitor.Exit(players);
                }
                return count;
            }
        }

        public int TurnIndex
        {
            get
            {
                return this.m_turnIndex;
            }
            set
            {
                this.m_turnIndex = value;
            }
        }

        public eGameState GameState
        {
            get
            {
                return this.m_gameState;
            }
        }
        internal void SendLivingWalk(Living living, int fromX, int fromY, int toX, int toY, string action, int speed, string sAction)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.GAME_CMD, living.Id);
            pkg.Parameter1 = living.Id;
            pkg.WriteByte((byte)eTankCmdType.LIVING_MOVETO);
            pkg.WriteInt(fromX);
            pkg.WriteInt(fromY);
            pkg.WriteInt(toX);
            pkg.WriteInt(toY);
            pkg.WriteInt(speed);
            pkg.WriteString(!string.IsNullOrEmpty(action) ? action : "");
            pkg.WriteString(sAction);
            SendToAll(pkg);
        }  
        public float Wind
        {
            get
            {
                return this.m_map.wind;
            }
        }

        public Map Map
        {
            get
            {
                return this.m_map;
            }
        }

        public List<TurnedLiving> TurnQueue
        {
            get
            {
                return this.m_turnQueue;
            }
        }

        public bool HasPlayer
        {
            get
            {
                return this.m_players.Count > 0;
            }
        }

        public Random Random
        {
            get
            {
                return this.m_random;
            }
        }

        public TurnedLiving CurrentLiving
        {
            get
            {
                return this.m_currentLiving;
            }
        }

        public int LifeTime
        {
            get
            {
                return this.m_lifeTime;
            }
        }

        public BaseGame(int id, int roomId, Map map, eRoomType roomType, eGameType gameType, int timeType)
            : base(id, roomType, gameType, timeType)
        {
            this.m_roomId = roomId;
            this.m_players = new Dictionary<int, Player>();
            this.m_turnQueue = new List<TurnedLiving>();
            this.m_livings = new List<Living>();
            this.m_random = new Random();
            this.m_map = map;
            this.m_actions = new ArrayList();
            this.PhysicalId = 0;
            this.BossWarField = "";
            this.m_tempBox = new List<Box>();
            this.m_tempPoints = new List<Point>();
            this.GameNeedPetSkillInfo = PetMgr.GameNeedPetSkill();
            if (roomType == eRoomType.Dungeon)
            {
                this.Cards = new int[21];
            }
            else
            {
                this.Cards = new int[9];
            }
            this.m_gameState = eGameState.Inited;
        }

        public void SetWind(int wind)
        {
            this.m_map.wind = (float)wind;
        }

        public bool SetMap(int mapId)
        {
            bool result;
            if (this.GameState == eGameState.Playing)
            {
                result = false;
            }
            else
            {
                Map map = MapMgr.CloneMap(mapId);
                if (map != null)
                {
                    this.m_map = map;
                    result = true;
                }
                else
                {
                    result = false;
                }
            }
            return result;
        }

        public int GetTurnWaitTime()
        {
            return this.m_timeType;
        }

        protected void AddPlayer(IGamePlayer gp, Player fp)
        {
            Dictionary<int, Player> players;
            Monitor.Enter(players = this.m_players);
            try
            {
                this.m_players.Add(fp.Id, fp);
                if (fp.Weapon != null)
                {
                    this.m_turnQueue.Add(fp);
                }
            }
            finally
            {
                Monitor.Exit(players);
            }
        }

        public virtual void AddLiving(Living living)
        {
            this.m_map.AddPhysical(living);
            if (living is Player)
            {
                Player player = living as Player;
                if (player.Weapon == null)
                {
                    return;
                }
            }
            if (living is TurnedLiving)
            {
                this.m_turnQueue.Add(living as TurnedLiving);
            }
            else
            {
                this.m_livings.Add(living);
            }
            this.SendAddLiving(living);
        }

        public virtual void AddPhysicalObj(PhysicalObj phy, bool sendToClient)
        {
            this.m_map.AddPhysical(phy);
            phy.SetGame(this);
            if (sendToClient)
            {
                this.SendAddPhysicalObj(phy);
            }
        }

        public virtual void AddPhysicalTip(PhysicalObj phy, bool sendToClient)
        {
            this.m_map.AddPhysical(phy);
            phy.SetGame(this);
            if (sendToClient)
            {
                this.SendAddPhysicalTip(phy);
            }
        }

        public override Player RemovePlayer(IGamePlayer gp, bool IsKick)
        {
            Player player = null;
            Dictionary<int, Player> players;
            Monitor.Enter(players = this.m_players);
            try
            {
                foreach (Player p in this.m_players.Values)
                {
                    if (p.PlayerDetail == gp)
                    {
                        player = p;
                        this.m_players.Remove(p.Id);
                        break;
                    }
                }
            }
            finally
            {
                Monitor.Exit(players);
            }
            if (player != null)
            {
                this.AddAction(new RemovePlayerAction(player));
            }
            return player;
        }

        public void RemovePhysicalObj(PhysicalObj phy, bool sendToClient)
        {
            this.m_map.RemovePhysical(phy);
            phy.SetGame(null);
            if (sendToClient)
            {
                this.SendRemovePhysicalObj(phy);
            }
        }

        public void RemoveLiving(int id)
        {
            this.SendRemoveLiving(id);
        }

        public List<Living> GetLivedLivings()
        {
            List<Living> temp = new List<Living>();
            foreach (Living living in this.m_livings)
            {
                if (living.IsLiving)
                {
                    temp.Add(living);
                }
            }
            return temp;
        }

        public void ClearDiedPhysicals()
        {
            List<Living> temp = new List<Living>();
            foreach (Living living in this.m_livings)
            {
                if (!living.IsLiving)
                {
                    temp.Add(living);
                }
            }
            foreach (Living living in temp)
            {
                this.m_livings.Remove(living);
                living.Dispose();
            }
            List<Living> turnedTemp = new List<Living>();
            foreach (TurnedLiving turnedLiving in this.m_turnQueue)
            {
                if (!turnedLiving.IsLiving)
                {
                    turnedTemp.Add(turnedLiving);
                }
            }
            using (List<Living>.Enumerator enumerator = turnedTemp.GetEnumerator())
            {
                while (enumerator.MoveNext())
                {
                    TurnedLiving turnedLiving = (TurnedLiving)enumerator.Current;
                    this.m_turnQueue.Remove(turnedLiving);
                }
            }
            List<Physics> phys = this.m_map.GetAllPhysicalSafe();
            foreach (Physics phy in phys)
            {
                if (!phy.IsLiving && !(phy is Player))
                {
                    this.m_map.RemovePhysical(phy);
                }
            }
        }

        public bool IsAllComplete()
        {
            List<Player> list = this.GetAllFightPlayers();
            bool result;
            foreach (Player player in list)
            {
                if (player.LoadingProcess < 100)
                {
                    result = false;
                    return result;
                }
            }
            result = true;
            return result;
        }

        public Player FindPlayer(int id)
        {
            Dictionary<int, Player> players;
            Monitor.Enter(players = this.m_players);
            Player result;
            try
            {
                if (this.m_players.ContainsKey(id))
                {
                    result = this.m_players[id];
                    return result;
                }
            }
            finally
            {
                Monitor.Exit(players);
            }
            result = null;
            return result;
        }

        public TurnedLiving FindNextTurnedLiving()
        {
            TurnedLiving result;
            if (this.m_turnQueue.Count == 0)
            {
                result = null;
            }
            else
            {
                int start = this.m_random.Next(this.m_turnQueue.Count - 1);
                TurnedLiving player = this.m_turnQueue[start];
                int delay = player.Delay;
                for (int i = 0; i < this.m_turnQueue.Count; i++)
                {
                    if (this.m_turnQueue[i].Delay < delay && this.m_turnQueue[i].IsLiving)
                    {
                        delay = this.m_turnQueue[i].Delay;
                        player = this.m_turnQueue[i];
                    }
                }
                player.TurnNum++;
                result = player;
            }
            return result;
        }

        public virtual void MinusDelays(int lowestDelay)
        {
            foreach (TurnedLiving trunedLiving in this.m_turnQueue)
            {
                trunedLiving.Delay -= lowestDelay;
            }
        }

        public SimpleBoss[] FindAllBoss()
        {
            List<SimpleBoss> list = new List<SimpleBoss>();
            foreach (Living boss in this.m_livings)
            {
                if (boss is SimpleBoss)
                {
                    list.Add(boss as SimpleBoss);
                }
            }
            return list.ToArray();
        }

        public SimpleNpc[] FindAllNpc()
        {
            List<SimpleNpc> list = new List<SimpleNpc>();
            SimpleNpc[] result;
            foreach (Living npc in this.m_livings)
            {
                if (npc is SimpleNpc)
                {
                    list.Add(npc as SimpleNpc);
                    result = list.ToArray();
                    return result;
                }
            }
            result = null;
            return result;
        }

        public float GetNextWind()
        {
            int currentWind = (int)(this.Wind * 10f);
            int wind;
            if (currentWind > this.m_nextWind)
            {
                wind = currentWind - this.m_random.Next(11);
                if (currentWind <= this.m_nextWind)
                {
                    this.m_nextWind = this.m_random.Next(-40, 40);
                }
            }
            else
            {
                wind = currentWind + this.m_random.Next(11);
                if (currentWind >= this.m_nextWind)
                {
                    this.m_nextWind = this.m_random.Next(-40, 40);
                }
            }
            return (float)wind / 10f;
        }

        public void UpdateWind(float wind, bool sendToClient)
        {
            if (this.m_map.wind != wind)
            {
                this.m_map.wind = wind;
                if (sendToClient)
                {
                    this.SendGameUpdateWind(wind);
                }
            }
        }

        public int GetDiedPlayerCount()
        {
            int count = 0;
            foreach (Player player in this.m_players.Values)
            {
                if (player.IsActive && !player.IsLiving)
                {
                    count++;
                }
            }
            return count;
        }

        protected Point GetPlayerPoint(MapPoint mapPos, int team)
        {
            List<Point> list = (team == 1) ? mapPos.PosX : mapPos.PosX1;
            int rand = this.m_random.Next(list.Count);
            Point pos = list[rand];
            list.Remove(pos);
            return pos;
        }

        public virtual void CheckState(int delay)
        {
        }

        public override void ProcessData(GSPacketIn packet)
        {
            if (this.m_players.ContainsKey(packet.Parameter1))
            {
                Player player = this.m_players[packet.Parameter1];
                this.AddAction(new ProcessPacketAction(player, packet));
            }
        }

        public Player GetPlayerByIndex(int index)
        {
            return this.m_players.ElementAt(index).Value;
        }

        public Player FindNearestPlayer(int x, int y)
        {
            double min = 1.7976931348623157E+308;
            Player player = null;
            foreach (Player p in this.m_players.Values)
            {
                if (p.IsLiving)
                {
                    double dis = p.Distance(x, y);
                    if (dis < min)
                    {
                        min = dis;
                        player = p;
                    }
                }
            }
            return player;
        }

        public Player FindRandomPlayer()
        {
            List<Player> list = new List<Player>();
            foreach (Player player in this.m_players.Values)
            {
                if (player.IsLiving)
                {
                    list.Add(player);
                }
            }
            int next = this.Random.Next(0, list.Count);
            return list.ElementAt(next);
        }

        public int FindlivingbyDir(Living npc)
        {
            int left = 0;
            int right = 0;
            foreach (Player p in this.m_players.Values)
            {
                if (p.IsLiving)
                {
                    if (p.X > npc.X)
                    {
                        right++;
                    }
                    else
                    {
                        left++;
                    }
                }
            }
            int result;
            if (right > left)
            {
                result = 1;
            }
            else
            {
                if (right < left)
                {
                    result = -1;
                }
                else
                {
                    result = -npc.Direction;
                }
            }
            return result;
        }

        public PhysicalObj[] FindPhysicalObjByName(string name)
        {
            List<PhysicalObj> phys = new List<PhysicalObj>();
            foreach (PhysicalObj phy in this.m_map.GetAllPhysicalObjSafe())
            {
                if (phy.Name == name)
                {
                    phys.Add(phy);
                }
            }
            return phys.ToArray();
        }

        public PhysicalObj[] FindPhysicalObjByName(string name, bool CanPenetrate)
        {
            List<PhysicalObj> phys = new List<PhysicalObj>();
            foreach (PhysicalObj phy in this.m_map.GetAllPhysicalObjSafe())
            {
                if (phy.Name == name && phy.CanPenetrate == CanPenetrate)
                {
                    phys.Add(phy);
                }
            }
            return phys.ToArray();
        }

        public Player GetFrostPlayerRadom()
        {
            List<Player> players = this.GetAllFightPlayers();
            List<Player> list = new List<Player>();
            foreach (Player player in players)
            {
                if (player.IsFrost)
                {
                    list.Add(player);
                }
            }
            Player result;
            if (list.Count > 0)
            {
                int next = this.Random.Next(0, list.Count);
                result = list.ElementAt(next);
            }
            else
            {
                result = null;
            }
            return result;
        }

        public virtual bool TakeCard(Player player)
        {
            return false;
        }

        public virtual bool TakeCard(Player player, int index)
        {
            return false;
        }

        public override void Pause(int time)
        {
            this.m_passTick = Math.Max(this.m_passTick, TickHelper.GetTickCount() + (long)time);
        }

        public override void Resume()
        {
            this.m_passTick = 0L;
        }

        public void AddAction(IAction action)
        {
            BaseGame.log.Info(action);
            ArrayList actions;
            Monitor.Enter(actions = this.m_actions);
            try
            {
                this.m_actions.Add(action);
            }
            finally
            {
                Monitor.Exit(actions);
            }
        }

        public void AddAction(ArrayList actions)
        {
            ArrayList actions2;
            Monitor.Enter(actions2 = this.m_actions);
            try
            {
                this.m_actions.AddRange(actions);
            }
            finally
            {
                Monitor.Exit(actions2);
            }
        }

        public void ClearWaitTimer()
        {
            this.m_waitTimer = 0L;
        }

        public void WaitTime(int delay)
        {
            this.m_waitTimer = Math.Max(this.m_waitTimer, TickHelper.GetTickCount() + (long)delay);
        }

        public long GetWaitTimer()
        {
            return this.m_waitTimer;
        }

        public void Update(long tick)
        {
            if (this.m_passTick < tick)
            {
                this.m_lifeTime++;
                ArrayList actions;
                Monitor.Enter(actions = this.m_actions);
                ArrayList temp;
                try
                {
                    temp = (ArrayList)this.m_actions.Clone();
                    this.m_actions.Clear();
                }
                finally
                {
                    Monitor.Exit(actions);
                }
                if (temp != null && this.GameState != eGameState.Stopped)
                {
                    this.CurrentActionCount = temp.Count;
                    if (temp.Count > 0)
                    {
                        ArrayList left = new ArrayList();
                        foreach (IAction action in temp)
                        {
                            try
                            {
                                action.Execute(this, tick);
                                if (!action.IsFinished(tick))
                                {
                                    left.Add(action);
                                }
                            }
                            catch (Exception ex)
                            {
                                BaseGame.log.Error("Falha ao Iniciar o mapa:", ex);
                            }
                        }
                        this.AddAction(left);
                    }
                    else
                    {
                        if (this.m_waitTimer < tick)
                        {
                            this.CheckState(0);
                        }
                    }
                }
            }
        }

        public List<Player> GetAllFightPlayers()
        {
            List<Player> list = new List<Player>();
            Dictionary<int, Player> players;
            Monitor.Enter(players = this.m_players);
            try
            {
                list.AddRange(this.m_players.Values);
            }
            finally
            {
                Monitor.Exit(players);
            }
            return list;
        }

        public List<Player> GetAllLivingPlayers()
        {
            List<Player> list = new List<Player>();
            Dictionary<int, Player> players;
            Monitor.Enter(players = this.m_players);
            try
            {
                foreach (Player livedPlayer in this.m_players.Values)
                {
                    if (livedPlayer.IsLiving)
                    {
                        list.Add(livedPlayer);
                    }
                }
            }
            finally
            {
                Monitor.Exit(players);
            }
            return list;
        }

        public bool GetSameTeam()
        {
            bool result = false;
            Player[] players = this.GetAllPlayers();
            Player[] array = players;
            for (int i = 0; i < array.Length; i++)
            {
                Player player = array[i];
                if (player.Team != players[0].Team)
                {
                    result = false;
                    break;
                }
                result = true;
            }
            return result;
        }

        public Player[] GetAllPlayers()
        {
            return this.GetAllFightPlayers().ToArray();
        }

        public Player GetPlayer(IGamePlayer gp)
        {
            Player player = null;
            Dictionary<int, Player> players;
            Monitor.Enter(players = this.m_players);
            try
            {
                foreach (Player p in this.m_players.Values)
                {
                    if (p.PlayerDetail == gp)
                    {
                        player = p;
                        break;
                    }
                }
            }
            finally
            {
                Monitor.Exit(players);
            }
            return player;
        }

        public int GetPlayerCount()
        {
            return this.GetAllFightPlayers().Count;
        }

        public virtual void SendToAll(GSPacketIn pkg)
        {
            this.SendToAll(pkg, null);
        }

        public virtual void SendToAll(GSPacketIn pkg, IGamePlayer except)
        {
            if (pkg.Parameter2 == 0)
            {
                pkg.Parameter2 = this.LifeTime;
            }
            List<Player> temp = this.GetAllFightPlayers();
            foreach (Player p in temp)
            {
                if (p.IsActive && p.PlayerDetail != except)
                {
                    p.PlayerDetail.SendTCP(pkg);
                }
            }
        }

        public virtual void SendToTeam(GSPacketIn pkg, int team)
        {
            this.SendToTeam(pkg, team, null);
        }

        public virtual void SendToTeam(GSPacketIn pkg, int team, IGamePlayer except)
        {
            List<Player> temp = this.GetAllFightPlayers();
            foreach (Player p in temp)
            {
                if (p.IsActive && p.PlayerDetail != except && p.Team == team)
                {
                    p.PlayerDetail.SendTCP(pkg);
                }
            }
        }

        public void AddTempPoint(int x, int y)
        {
            this.m_tempPoints.Add(new Point(x, y));
        }

        public Box AddBox(ItemInfo item, Point pos, bool sendToClient)
        {
            Box box = new Box(this.PhysicalId++, "1", item);
            box.SetXY(pos);
            this.AddPhysicalObj(box, sendToClient);
            return this.AddBox(box, sendToClient);
        }

        public Box AddBox(Box box, bool sendToClient)
        {
            this.m_tempBox.Add(box);
            this.AddPhysicalObj(box, sendToClient);
            return box;
        }

        public void CheckBox()
        {
            List<Box> temp = new List<Box>();
            foreach (Box box in this.m_tempBox)
            {
                if (!box.IsLiving)
                {
                    temp.Add(box);
                }
            }
            foreach (Box box in temp)
            {
                this.m_tempBox.Remove(box);
                this.RemovePhysicalObj(box, true);
            }
        }

        public List<Box> CreateBox()
        {
            int total = this.m_players.Count + 2;
            int itemCount = 0;
            List<ItemInfo> infos = null;
            if (this.CurrentTurnTotalDamage > 0)
            {
                itemCount = this.m_random.Next(1, 3);
                if (this.m_tempBox.Count + itemCount > total)
                {
                    itemCount = total - this.m_tempBox.Count;
                }
                if (itemCount > 0)
                {
                    DropInventory.BoxDrop(this.m_roomType, ref infos);
                }
            }
            int ghostCount = this.GetDiedPlayerCount();
            int propCount = 0;
            if (ghostCount > 0)
            {
                propCount = this.m_random.Next(ghostCount);
            }
            if (this.m_tempBox.Count + itemCount + propCount > total)
            {
                propCount = total - this.m_tempBox.Count - itemCount;
            }
            if (propCount > 0)
            {
            }
            List<Box> box = new List<Box>();
            if (infos != null)
            {
                for (int i = 0; i < this.m_tempPoints.Count; i++)
                {
                    int index = this.m_random.Next(this.m_tempPoints.Count);
                    Point p = this.m_tempPoints[index];
                    this.m_tempPoints[index] = this.m_tempPoints[i];
                    this.m_tempPoints[i] = p;
                }
                int count = Math.Min(infos.Count, this.m_tempPoints.Count);
                for (int i = 0; i < count; i++)
                {
                    box.Add(this.AddBox(infos[i], this.m_tempPoints[i], false));
                }
            }
            this.m_tempPoints.Clear();
            return box;
        }

        public void AddLoadingFile(int type, string file, string className)
        {
            if (file != null && className != null)
            {
                this.m_loadingFiles.Add(new LoadingFileInfo(type, file, className));
            }
        }

        public void ClearLoadingFiles()
        {
            this.m_loadingFiles.Clear();
        }

        public void AfterUseItem(ItemInfo item)
        {
        }

        internal void SendCreateGame()
        {
            GSPacketIn pkg = new GSPacketIn(91);
            pkg.WriteByte(101);
            pkg.WriteInt((int)((byte)this.m_roomType));
            pkg.WriteInt((int)((byte)this.m_gameType));
            pkg.WriteInt(this.m_timeType);
            List<Player> players = this.GetAllFightPlayers();
            pkg.WriteInt(players.Count);
            foreach (Player p in players)
            {
                IGamePlayer gp = p.PlayerDetail;
                pkg.WriteInt(4);
                pkg.WriteString("zonename");
                pkg.WriteInt(gp.PlayerCharacter.ID);
                pkg.WriteString(gp.PlayerCharacter.NickName);
                pkg.WriteBoolean(false);
                pkg.WriteByte(gp.PlayerCharacter.typeVIP);
                pkg.WriteInt(gp.PlayerCharacter.VIPLevel);
                pkg.WriteBoolean(gp.PlayerCharacter.Sex);
                pkg.WriteInt(gp.PlayerCharacter.Hide);
                pkg.WriteString(gp.PlayerCharacter.Style);
                pkg.WriteString(gp.PlayerCharacter.Colors);
                pkg.WriteString(gp.PlayerCharacter.Skin);
                pkg.WriteInt(gp.PlayerCharacter.Grade);
                pkg.WriteInt(gp.PlayerCharacter.Repute);
                pkg.WriteInt(gp.MainWeapon.TemplateID);
                pkg.WriteInt(gp.MainWeapon.RefineryLevel);
                pkg.WriteString(gp.MainWeapon.Name);
                pkg.WriteDateTime(DateTime.Now);
                if (gp.SecondWeapon == null)
                {
                    pkg.WriteInt(0);
                }
                else
                {
                    pkg.WriteInt(gp.SecondWeapon.TemplateID);
                }
                pkg.WriteInt(0);
                pkg.WriteInt(gp.PlayerCharacter.Nimbus);
                pkg.WriteBoolean(gp.PlayerCharacter.IsShowConsortia);
                pkg.WriteInt(gp.PlayerCharacter.ConsortiaID);
                pkg.WriteString(gp.PlayerCharacter.ConsortiaName);
                pkg.WriteInt(gp.PlayerCharacter.badgeID);
                pkg.WriteInt(0);
                pkg.WriteInt(0);
                pkg.WriteInt(gp.PlayerCharacter.Win);
                pkg.WriteInt(gp.PlayerCharacter.Total);
                pkg.WriteInt(gp.PlayerCharacter.FightPower);
                pkg.WriteInt(0);
                pkg.WriteInt(0);
                pkg.WriteString("");
                pkg.WriteInt(gp.PlayerCharacter.AchievementPoint);
                pkg.WriteString("");
                pkg.WriteInt(gp.PlayerCharacter.Offer);
                pkg.WriteBoolean(false);
                pkg.WriteInt(0);
                pkg.WriteBoolean(gp.PlayerCharacter.IsMarried);
                if (gp.PlayerCharacter.IsMarried)
                {
                    pkg.WriteInt(gp.PlayerCharacter.SpouseID);
                    pkg.WriteString(gp.PlayerCharacter.SpouseName);
                }
                pkg.WriteInt(5);
                pkg.WriteInt(5);
                pkg.WriteInt(5);
                pkg.WriteInt(5);
                pkg.WriteInt(5);
                pkg.WriteInt(5);
                pkg.WriteInt(p.Team);
                pkg.WriteInt(p.Id);
                pkg.WriteInt(p.MaxBlood);
                if (p.Pet != null)
                {
                    pkg.WriteInt(1);
                    pkg.WriteInt(p.Pet.Place);
                    pkg.WriteInt(p.Pet.TemplateID);
                    pkg.WriteInt(p.Pet.ID);
                    pkg.WriteString(p.Pet.Name);
                    pkg.WriteInt(p.Pet.UserID);
                    pkg.WriteInt(p.Pet.Level);
                    List<string> skillEquips = p.Pet.GetSkillEquip();
                    pkg.WriteInt(skillEquips.Count);
                    foreach (string skill in skillEquips)
                    {
                        pkg.WriteInt(int.Parse(skill.Split(new char[]
						{
							','
						})[1]));
                        pkg.WriteInt(int.Parse(skill.Split(new char[]
						{
							','
						})[0]));
                    }
                }
                else
                {
                    pkg.WriteInt(0);
                }
            }
            this.SendToAll(pkg);
        }

        internal void SendOpenSelectLeaderWindow(int maxTime)
        {
            GSPacketIn pkg = new GSPacketIn(91);
            pkg.WriteByte(102);
            pkg.WriteInt(maxTime);
            this.SendToAll(pkg);
        }

        internal void SendIsLastMission(bool isLast)
        {
            GSPacketIn pkg = new GSPacketIn(91);
            pkg.WriteByte(160);
            pkg.WriteBoolean(isLast);
            this.SendToAll(pkg);
        }

        internal void SendMissionTryAgain(int TryAgain)
        {
            GSPacketIn pkg = new GSPacketIn(91);
            pkg.WriteByte(119);
            pkg.WriteInt(TryAgain);
            this.SendToAll(pkg);
        }

        internal bool isTrainer()
        {
            int iD = this.m_map.Info.ID;
            if (iD <= 1129)
            {
                if (iD != 1015 && iD != 1129)
                {
                    goto IL_4E;
                }
            }
            else
            {
                if (iD != 1132)
                {
                    switch (iD)
                    {
                        case 2012:
                        case 2013:
                            break;

                        default:
                            goto IL_4E;
                    }
                }
            }
            bool result = true;
            return result;
        IL_4E:
            result = false;
            return result;
        }

        internal void SendStartLoading(int maxTime)
        {
            GSPacketIn pkg = new GSPacketIn(91);
            pkg.WriteByte(103);
            pkg.WriteInt(maxTime);
            pkg.WriteInt(this.m_map.Info.ID);
            pkg.WriteInt(this.m_loadingFiles.Count);
            foreach (LoadingFileInfo file in this.m_loadingFiles)
            {
                pkg.WriteInt(file.Type);
                pkg.WriteString(file.Path);
                pkg.WriteString(file.ClassName);
            }
            if (this.isTrainer())
            {
                pkg.WriteInt(0);
            }
            else
            {
                pkg.WriteInt(this.GameNeedPetSkillInfo.Count);
                foreach (PetSkillElementInfo info in this.GameNeedPetSkillInfo)
                {
                    pkg.WriteString(info.Pic.ToString());
                    pkg.WriteString(info.EffectPic);
                }
            }
            this.SendToAll(pkg);
        }

        internal void SendAddPhysicalObj(PhysicalObj obj)
        {
            GSPacketIn pkg = new GSPacketIn(91);
            pkg.WriteByte(48);
            pkg.WriteInt(obj.Id);
            pkg.WriteInt(obj.Type);
            pkg.WriteInt(obj.X);
            pkg.WriteInt(obj.Y);
            pkg.WriteString(obj.Model);
            pkg.WriteString(obj.CurrentAction);
            pkg.WriteInt(obj.Scale);
            pkg.WriteInt(obj.Scale);
            pkg.WriteInt(obj.Rotation);
            pkg.WriteInt(-1);
            pkg.WriteInt(0);
            this.SendToAll(pkg);
        }

        internal void SendAddPhysicalTip(PhysicalObj obj)
        {
            GSPacketIn pkg = new GSPacketIn(91);
            pkg.WriteByte(68);
            pkg.WriteInt(obj.Id);
            pkg.WriteInt(obj.Type);
            pkg.WriteInt(obj.X);
            pkg.WriteInt(obj.Y);
            pkg.WriteString(obj.Model);
            pkg.WriteString(obj.CurrentAction);
            pkg.WriteInt(obj.Scale);
            pkg.WriteInt(obj.Rotation);
            this.SendToAll(pkg);
        }

        internal void SendPhysicalObjFocus(Physics obj, int type)
        {
            GSPacketIn pkg = new GSPacketIn(91);
            pkg.WriteByte(62);
            pkg.WriteInt(type);
            pkg.WriteInt(obj.X);
            pkg.WriteInt(obj.Y);
            this.SendToAll(pkg);
        }

        internal void SendPhysicalObjPlayAction(PhysicalObj obj)
        {
            GSPacketIn pkg = new GSPacketIn(91);
            pkg.WriteByte(66);
            pkg.WriteInt(obj.Id);
            pkg.WriteString(obj.CurrentAction);
            this.SendToAll(pkg);
        }

        internal void SendRemovePhysicalObj(PhysicalObj obj)
        {
            GSPacketIn pkg = new GSPacketIn(91);
            pkg.WriteByte(53);
            pkg.WriteInt(obj.Id);
            this.SendToAll(pkg);
        }

        internal void SendRemoveLiving(int id)
        {
            GSPacketIn pkg = new GSPacketIn(91);
            pkg.WriteByte(53);
            pkg.WriteInt(id);
            this.SendToAll(pkg);
        }

        internal void SendAddLiving(Living living)
        {
            GSPacketIn pkg = new GSPacketIn(91);
            pkg.Parameter1 = living.Id;
            pkg.WriteByte(64);
            pkg.WriteByte((byte)living.Type);
            pkg.WriteInt(living.Id);
            pkg.WriteString(living.Name);
            pkg.WriteString(living.ModelId);
            pkg.WriteString(living.ActionStr);
            pkg.WriteInt(living.X);
            pkg.WriteInt(living.Y);
            pkg.WriteInt(living.Blood);
            pkg.WriteInt(living.MaxBlood);
            pkg.WriteInt(living.Team);
            pkg.WriteByte((byte)living.Direction);
            byte isBotom = 0;
            if (living is SimpleBoss)
            {
                isBotom = 1;
            }
            pkg.WriteByte(isBotom);
            this.SendToAll(pkg);
        }

        internal void SendPlayerMove(Player player, int type, int x, int y, byte dir)
        {
            GSPacketIn pkg = new GSPacketIn(91, player.Id);
            pkg.Parameter1 = player.Id;
            pkg.WriteByte(9);
            pkg.WriteByte((byte)type);
            pkg.WriteInt(x);
            pkg.WriteInt(y);
            pkg.WriteByte(dir);
            pkg.WriteBoolean(player.IsLiving);
            if (type == 2)
            {
                pkg.WriteInt(this.m_tempBox.Count);
                foreach (Box box in this.m_tempBox)
                {
                    pkg.WriteInt(box.X);
                    pkg.WriteInt(box.Y);
                }
            }
            this.SendToAll(pkg);
        }

        internal void SendLivingMoveTo(Living living, int fromX, int fromY, int toX, int toY, string action, int speed, string sAction)
        {
            GSPacketIn pkg = new GSPacketIn(91, living.Id);
            pkg.Parameter1 = living.Id;
            pkg.WriteByte(55);
            pkg.WriteInt(fromX);
            pkg.WriteInt(fromY);
            pkg.WriteInt(toX);
            pkg.WriteInt(toY);
            pkg.WriteInt(speed);
            pkg.WriteString((!string.IsNullOrEmpty(action)) ? action : "");
            pkg.WriteString(sAction);
            this.SendToAll(pkg);
        }

        internal void SendLivingSay(Living living, string msg, int type)
        {
            GSPacketIn pkg = new GSPacketIn(91, living.Id);
            pkg.Parameter1 = living.Id;
            pkg.WriteByte(59);
            pkg.WriteString(msg);
            pkg.WriteInt(type);
            this.SendToAll(pkg);
        }

        internal void SendLivingFall(Living living, int toX, int toY, int speed, string action, int type)
        {
            GSPacketIn pkg = new GSPacketIn(91, living.Id);
            pkg.Parameter1 = living.Id;
            pkg.WriteByte(56);
            pkg.WriteInt(toX);
            pkg.WriteInt(toY);
            pkg.WriteInt(speed);
            pkg.WriteString((!string.IsNullOrEmpty(action)) ? action : "");
            pkg.WriteInt(type);
            this.SendToAll(pkg);
        }

        internal void SendLivingJump(Living living, int toX, int toY, int speed, string action, int type)
        {
            GSPacketIn pkg = new GSPacketIn(91, living.Id);
            pkg.Parameter1 = living.Id;
            pkg.WriteByte(57);
            pkg.WriteInt(toX);
            pkg.WriteInt(toY);
            pkg.WriteInt(speed);
            pkg.WriteString((!string.IsNullOrEmpty(action)) ? action : "");
            pkg.WriteInt(type);
            this.SendToAll(pkg);
        }

        internal void SendLivingBeat(Living living, Living target, int totalDemageAmount, string action, int livingCount, int attackEffect)
        {
            int dander = 0;
            if (target is Player)
            {
                Player p = target as Player;
                dander = p.Dander;
            }
            GSPacketIn pkg = new GSPacketIn(91, living.Id);
            pkg.Parameter1 = living.Id;
            pkg.WriteByte(58);
            pkg.WriteString((!string.IsNullOrEmpty(action)) ? action : "");
            pkg.WriteInt(livingCount);
            for (int i = 1; i <= livingCount; i++)
            {
                pkg.WriteInt(target.Id);
                pkg.WriteInt(totalDemageAmount);
                pkg.WriteInt(target.Blood);
                pkg.WriteInt(dander);
                pkg.WriteInt(attackEffect);
            }
            this.SendToAll(pkg);
        }

        internal void SendLivingPlayMovie(Living living, string action)
        {
            GSPacketIn pkg = new GSPacketIn(91, living.Id);
            pkg.Parameter1 = living.Id;
            pkg.WriteByte(60);
            pkg.WriteString(action);
            this.SendToAll(pkg);
        }

        internal void SendGameUpdateHealth(Living player, int type, int value)
        {
            GSPacketIn pkg = new GSPacketIn(91, player.Id);
            pkg.Parameter1 = player.Id;
            pkg.WriteByte(11);
            pkg.WriteByte((byte)type);
            pkg.WriteInt(player.Blood);
            pkg.WriteInt(value);
            this.SendToAll(pkg);
        }

        internal void SendGameUpdateDander(TurnedLiving player)
        {
            GSPacketIn pkg = new GSPacketIn(91, player.Id);
            pkg.Parameter1 = player.Id;
            pkg.WriteByte(14);
            pkg.WriteInt(player.Dander);
            this.SendToAll(pkg);
        }

        internal void SendGameUpdateFrozenState(Living player)
        {
            GSPacketIn pkg = new GSPacketIn(91, player.Id);
            pkg.Parameter1 = player.Id;
            pkg.WriteByte(33);
            pkg.WriteBoolean(player.IsFrost);
            this.SendToAll(pkg);
        }

        internal void SendGameUpdateNoHoleState(Living player)
        {
            GSPacketIn pkg = new GSPacketIn(91, player.Id);
            pkg.Parameter1 = player.Id;
            pkg.WriteByte(82);
            pkg.WriteBoolean(player.IsNoHole);
            this.SendToAll(pkg);
        }

        internal void SendGameUpdateHideState(Living player)
        {
            GSPacketIn pkg = new GSPacketIn(91, player.Id);
            pkg.Parameter1 = player.Id;
            pkg.WriteByte(35);
            pkg.WriteBoolean(player.IsHide);
            this.SendToAll(pkg);
        }

        internal void SendGameUpdateShootCount(Player player)
        {
            GSPacketIn pkg = new GSPacketIn(91, player.Id);
            pkg.WriteByte(46);
            pkg.WriteByte((byte)player.ShootCount);
            this.SendToAll(pkg);
        }

        internal void SendGameUpdateBall(Player player, bool Special)
        {
            GSPacketIn pkg = new GSPacketIn(91, player.Id);
            pkg.Parameter1 = player.Id;
            pkg.WriteByte(20);
            pkg.WriteBoolean(Special);
            pkg.WriteInt(player.CurrentBall.ID);
            this.SendToAll(pkg);
        }

        internal void SendGamePickBox(Living player, int index, int arkType, string goods)
        {
            GSPacketIn pkg = new GSPacketIn(91, player.Id);
            pkg.WriteByte(49);
            pkg.WriteByte((byte)index);
            pkg.WriteByte((byte)arkType);
            pkg.WriteString(goods);
            this.SendToAll(pkg);
        }

        internal void SendGameUpdateWind(float wind)
        {
            GSPacketIn pkg = new GSPacketIn(91);
            pkg.WriteByte(38);
            int _wind = (int)(wind * 10f);
            pkg.WriteInt(_wind);
            pkg.WriteBoolean(_wind > 0);
            pkg.WriteByte(this.GetVane(_wind, 1));
            pkg.WriteByte(this.GetVane(_wind, 2));
            pkg.WriteByte(this.GetVane(_wind, 3));
            this.SendToAll(pkg);
        }

        public byte GetVane(int Wind, int param)
        {
            int _wind = Math.Abs(Wind);
            byte result;
            switch (param)
            {
                case 1:
                    result = (byte)WindMgr.FindVane(_wind).VaneId1;
                    return result;
                case 3:
                    result = (byte)WindMgr.FindVane(_wind).VaneId3;
                    return result;
            }
            result = 0;
            return result;
        }

        public void VaneLoading()
        {
            for (int wind_id = 0; wind_id < 11; wind_id++)
            {
                if (wind_id == 0)
                {
                    this.SendGameWindPic((byte)WindMgr.FindVane(wind_id).VaneId2, WindMgr.FindVane(wind_id).Param2);
                }
                else
                {
                    this.SendGameWindPic((byte)WindMgr.FindVane(wind_id).VaneId3, WindMgr.FindVane(wind_id).Param3);
                }
            }
        }

        internal void SendGameWindPic(byte windId, byte[] windpic)
        {
            GSPacketIn pkg = new GSPacketIn(91);
            pkg.WriteByte(241);
            pkg.WriteByte(windId);
            pkg.Write(windpic);
            this.SendToAll(pkg);
        }

        internal void SendPetUseKill(Player player, int killId, bool isUse)
        {
            GSPacketIn pkg = new GSPacketIn(91, player.Id);
            pkg.Parameter1 = player.Id;
            pkg.WriteByte(144);
            pkg.WriteInt(killId);
            pkg.WriteBoolean(isUse);
            this.SendToAll(pkg);
        }

        internal void SendUseDeputyWeapon(Player player, int ResCount)
        {
            GSPacketIn pkg = new GSPacketIn(91, player.Id);
            pkg.Parameter1 = player.Id;
            pkg.WriteByte(84);
            pkg.WriteInt(ResCount);
            this.SendToAll(pkg);
        }

        internal void SendPlayerUseProp(Player player, int type, int place, int templateID)
        {
            GSPacketIn pkg = new GSPacketIn(91, player.Id);
            pkg.Parameter1 = player.Id;
            pkg.WriteByte(32);
            pkg.WriteByte((byte)type);
            pkg.WriteInt(place);
            pkg.WriteInt(templateID);
            pkg.WriteInt(player.Id);
            pkg.WriteBoolean(false);
            this.SendToAll(pkg);
        }

        internal void SendGamePlayerTakeCard(Player player, int index, int templateID, int count, bool isSysTake)
        {
            GSPacketIn pkg = new GSPacketIn(91, player.Id);
            pkg.Parameter1 = player.Id;
            pkg.WriteByte(98);
            pkg.WriteBoolean(isSysTake);
            pkg.WriteByte((byte)index);
            pkg.WriteInt(templateID);
            pkg.WriteInt(count);
            pkg.WriteBoolean(false);
            this.SendToAll(pkg);
        }

        public static int getTurnTime(int timeType)
        {
            int result;
            switch (timeType)
            {
                case 1:
                    result = 6;
                    break;

                case 2:
                    result = 8;
                    break;

                case 3:
                    result = 11;
                    break;

                case 4:
                    result = 16;
                    break;

                case 5:
                    result = 21;
                    break;

                case 6:
                    result = 31;
                    break;

                default:
                    result = -1;
                    break;
            }
            return result;
        }

        internal void SendGameNextTurn(Living living, BaseGame game, List<Box> newBoxes)
        {
            GSPacketIn pkg = new GSPacketIn(91, living.Id);
            pkg.Parameter1 = living.Id;
            pkg.WriteByte(6);
            int _wind = (int)(this.m_map.wind * 10f);
            pkg.WriteBoolean(_wind > 0);
            pkg.WriteByte(this.GetVane(_wind, 1));
            pkg.WriteByte(this.GetVane(_wind, 2));
            pkg.WriteByte(this.GetVane(_wind, 3));
            pkg.WriteBoolean(living.IsHide);
            pkg.WriteInt(BaseGame.getTurnTime(base.TimeType));
            pkg.WriteInt(newBoxes.Count);
            foreach (Box box in newBoxes)
            {
                pkg.WriteInt(box.Id);
                pkg.WriteInt(box.X);
                pkg.WriteInt(box.Y);
                pkg.WriteInt(box.Type);
            }
            List<Player> list = game.GetAllFightPlayers();
            pkg.WriteInt(list.Count);
            foreach (Player player in list)
            {
                pkg.WriteInt(player.Id);
                pkg.WriteBoolean(player.IsLiving);
                pkg.WriteInt(player.X);
                pkg.WriteInt(player.Y);
                pkg.WriteInt(player.Blood);
                pkg.WriteBoolean(player.IsNoHole);
                pkg.WriteInt(player.Energy);
                pkg.WriteInt(player.psychic);
                pkg.WriteInt(player.Dander);
                if (player.Pet == null)
                {
                    pkg.WriteInt(0);
                    pkg.WriteInt(0);
                }
                else
                {
                    pkg.WriteInt(player.PetMaxMP);
                    pkg.WriteInt(player.PetMP);
                }
                pkg.WriteInt(player.ShootCount);
            }
            pkg.WriteInt(game.TurnIndex);
            this.SendToAll(pkg);
        }

        internal void SendLivingUpdateDirection(Living living)
        {
            GSPacketIn pkg = new GSPacketIn(91);
            pkg.Parameter1 = living.Id;
            pkg.WriteByte(7);
            pkg.WriteInt(living.Direction);
            this.SendToAll(pkg);
        }

        internal void SendLivingUpdateAngryState(Living living)
        {
            GSPacketIn pkg = new GSPacketIn(91);
            pkg.Parameter1 = living.Id;
            pkg.WriteByte(118);
            pkg.WriteInt(living.State);
            this.SendToAll(pkg);
        }

        internal void SendEquipEffect(Living player, string buffer)
        {
            GSPacketIn pkg = new GSPacketIn(3);
            pkg.WriteInt(0);
            pkg.WriteString(buffer);
            this.SendToAll(pkg);
        }

        internal void SendMessage(IGamePlayer player, string msg, string msg1, int type)
        {
            if (msg != null)
            {
                GSPacketIn pkg = new GSPacketIn(3);
                pkg.WriteInt(type);
                pkg.WriteString(msg);
                player.SendTCP(pkg);
            }
            if (msg1 != null)
            {
                GSPacketIn pkg = new GSPacketIn(3);
                pkg.WriteInt(type);
                pkg.WriteString(msg1);
                this.SendToAll(pkg, player);
            }
        }

        internal void SendPlayerPicture(Living living, int type, bool state)
        {
            GSPacketIn pkg = new GSPacketIn(91);
            pkg.Parameter1 = living.Id;
            pkg.WriteByte(128);
            pkg.WriteInt(type);
            pkg.WriteBoolean(state);
            this.SendToAll(pkg);
        }

        internal void SendPlayerRemove(Player player)
        {
            GSPacketIn pkg = new GSPacketIn(94, player.PlayerDetail.PlayerCharacter.ID);
            pkg.WriteByte(5);
            pkg.WriteInt(4);
            this.SendToAll(pkg);
        }

        internal void SendSyncLifeTime()
        {
            GSPacketIn pkg = new GSPacketIn(91);
            pkg.WriteByte(131);
            pkg.WriteInt(this.m_lifeTime);
            this.SendToAll(pkg);
        }

        protected void OnGameOverred()
        {
            if (this.GameOverred != null)
            {
                this.GameOverred(this);
            }
        }

        protected void OnBeginNewTurn()
        {
            if (this.BeginNewTurn != null)
            {
                this.BeginNewTurn(this);
            }
        }

        public void OnGameOverLog(int _roomId, eRoomType _roomType, eGameType _fightType, int _changeTeam, DateTime _playBegin, DateTime _playEnd, int _userCount, int _mapId, string _teamA, string _teamB, string _playResult, int _winTeam, string BossWar)
        {
            if (this.GameOverLog != null)
            {
                this.GameOverLog(_roomId, _roomType, _fightType, _changeTeam, _playBegin, _playEnd, _userCount, _mapId, _teamA, _teamB, _playResult, _winTeam, this.BossWarField);
            }
        }

        public void OnGameNpcDie(int Id)
        {
            if (this.GameNpcDie != null)
            {
                this.GameNpcDie(Id);
            }
        }

        public override string ToString()
        {
            return string.Format("Id:{0},player:{1},state:{2},current:{3},turnIndex:{4},actions:{5}", new object[]
			{
				base.Id,
				this.PlayerCount,
				this.GameState,
				this.CurrentLiving,
				this.m_turnIndex,
				this.m_actions.Count
			});
        }
    }
}