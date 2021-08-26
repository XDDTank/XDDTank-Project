﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Base.Packets;
using Game.Logic.Phy.Maps;
using Game.Logic.Phy.Actions;
using SqlDataProvider.Data;
using System.Drawing;
using Game.Logic.Actions;
using Game.Server;
using Game.Logic.Effects;
using System.Security.Cryptography;
using Game.Logic.Phy.Object;
using Bussiness;
using log4net;
using System.Reflection;

namespace Game.Logic.Phy.Object
{
    public class Living : Physics
    {
        private static readonly new ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        protected BaseGame m_game;

        protected int m_maxBlood;
        protected int m_blood;
        private int m_team;
        private string m_name;
        private string m_action;
        private string m_modelId;
        private Rectangle m_demageRect;
        private int m_state;
        public int m_direction;
        private eLivingType m_type;

        public double BaseDamage = 10;
        public double BaseGuard = 10;

        public double Defence = 10;
        public double Attack = 10;
        public double Agility = 10;
        public double Lucky = 10;

        public int Grade = 1;
        public int Experience = 10;

        public float CurrentDamagePlus;
        public float CurrentShootMinus;
        public bool IgnoreArmor;
        public bool ControlBall;
        public bool NoHoleTurn;
        public bool CurrentIsHitTarget;

        public int TurnNum;
        public int TotalHurt;
        public int TotalHitTargetCount;
        public int TotalShootCount;
        public int TotalKill;
        public int MaxBeatDis;
        public int EffectsCount;
        public int ShootMovieDelay;

        private EffectList m_effectList;
        public bool EffectTrigger;
        private bool m_noTakeDamage;
        protected bool m_syncAtTime;
        private bool m_isPet;
        private bool m_activePetHit;
        private int m_petBaseAtt;
        private bool m_critActive;

        public Living(int id, BaseGame game, int team, string name, string modelId, int maxBlood, int immunity, int direction)
            : base(id)
        {
            m_critActive = false;
            m_petBaseAtt = 0;
            m_activePetHit = false;
            m_isPet = false;
            m_noTakeDamage = true;
            m_action = "";
            m_game = game;
            m_team = team;
            m_name = name;
            m_modelId = modelId;
            m_maxBlood = maxBlood;
            m_direction = direction;
            m_state = 0;
            MaxBeatDis = 100;
            m_effectList = new EffectList(this, immunity);
            m_syncAtTime = true;
            m_type = eLivingType.Living;
        }
        public bool critActive
        {
            get { return m_critActive; }
            set { m_critActive = value; }
        }
        public bool isPet
        {
            get { return m_isPet; }
            set { m_isPet = value; }
        }
        public bool activePetHit
        {
            get { return m_activePetHit; }
            set { m_activePetHit = value; }
        }
        public int PetBaseAtt
        {
            get { return m_petBaseAtt; }
            set { m_petBaseAtt = value; }
        }
        public bool NoTakeDamage
        {
            get { return m_noTakeDamage; }
            set { m_noTakeDamage = value; }
        }
        public string ActionStr
        {
            get { return m_action; }
            set { m_action = value; }
        }
        public BaseGame Game
        {
            get { return m_game; }
        }

        public string Name
        {
            get { return m_name; }
        }

        public string ModelId
        {
            get { return m_modelId; }
        }

        public int Team
        {
            get { return m_team; }
            //set { m_team = value; }
        }

        public bool SyncAtTime
        {
            get { return m_syncAtTime; }
            set { m_syncAtTime = value; }
        }

        public int Direction
        {
            get { return m_direction; }
            set
            {
                if (m_direction != value)
                {
                    m_direction = value;

                    SetRect(-m_rect.X - m_rect.Width, m_rect.Y, m_rect.Width, m_rect.Height);
                    SetRectBomb(-m_rectBomb.X - m_rectBomb.Width, m_rectBomb.Y, m_rectBomb.Width, m_rectBomb.Height);
                    SetRelateDemagemRect(-m_demageRect.X - m_demageRect.Width, m_demageRect.Y, m_demageRect.Width, m_demageRect.Height);
                    if (m_syncAtTime)
                    {
                        m_game.SendLivingUpdateDirection(this);
                    }
                }
            }
        }

        public void SetRelateDemagemRect(int x, int y, int width, int height)
        {

            m_demageRect.X = x;
            m_demageRect.Y = y;
            m_demageRect.Width = width;
            m_demageRect.Height = height;
        }

        public Point GetShootPoint()
        {
            if (this is SimpleBoss)
            {
                return m_direction > 0 ? new Point(X - ((SimpleBoss)this).NpcInfo.FireX, Y + ((SimpleBoss)this).NpcInfo.FireY) : new Point(X + ((SimpleBoss)this).NpcInfo.FireX, Y + ((SimpleBoss)this).NpcInfo.FireY);
            }
            else
            {
                return m_direction > 0 ? new Point(X - m_rect.X + 5, Y + m_rect.Y - 5) : new Point(X + m_rect.X - 5, Y + m_rect.Y - 5);
            }

        }


        public Rectangle GetDirectDemageRect()
        {

            //return m_direction > 0 ? new Rectangle(X - m_demageRect.X, Y + m_demageRect.Y, m_demageRect.Width, m_demageRect.Height) : new Rectangle(X + m_demageRect.X, Y + m_demageRect.Y, m_demageRect.Width, m_demageRect.Height);
            return new Rectangle(X + m_demageRect.X, Y + m_demageRect.Y, m_demageRect.Width, m_demageRect.Height);
        }

        public List<Rectangle> GetDirectBoudRect()
        {
            List<Rectangle> list = new List<Rectangle>();
            list.Add(new Rectangle(X + Bound.X, Y + Bound.Y, Bound.Width, Bound.Height));
            list.Add(new Rectangle(X + Bound1.X, Y + Bound1.Y, Bound1.Width, Bound1.Height));
            //list.Add(m_direction > 0 ? new Rectangle(X - Bound.X, Y + Bound.Y, Bound.Width, Bound.Height) : new Rectangle(X + Bound.X, Y + Bound.Y, Bound.Width, Bound.Height));
            //list.Add(m_direction > 0 ? new Rectangle(X - Bound1.X, Y + Bound1.Y, Bound1.Width, Bound1.Height) : new Rectangle(X + Bound1.X, Y + Bound1.Y, Bound1.Width, Bound1.Height));
            return list;
        }
        public bool WalkTo(int x, int y, string action, int delay, string sAction, int speed)
        {
            return this.WalkTo(x, y, action, delay, sAction, speed, null);
        }

        public bool WalkTo(int x, int y, string action, int delay, string sAction, int speed, LivingCallBack callback)
        {
            if ((base.m_x != x) || (base.m_y != y))
            {
                if ((x < 0) || (x > base.m_map.Bound.Width))
                {
                    return false;
                }
                List<Point> path = new List<Point>();
                int num = base.m_x;
                int num2 = base.m_y;
                int direction = (x > num) ? 1 : -1;
                if (!(action == "fly"))
                {
                    while (((x - num) * direction) > 0)
                    {
                        Point item = base.m_map.FindNextWalkPoint(num, num2, direction, STEP_X, STEP_Y);
                        if (!(item != Point.Empty))
                        {
                            break;
                        }
                        path.Add(item);
                        num = item.X;
                        num2 = item.Y;
                    }
                }
                else
                {
                    Point point = new Point(x, y);
                    Point point2 = new Point(num - point.X, num2 - point.Y);
                    point = new Point(point.X + point2.X, y + point2.X);
                    point2 = new Point(x - point.X, x - point.Y);
                    bool flag1 = point != Point.Empty;
                    point = new Point(x, y);
                    path.Add(point);
                }
                if (path.Count > 0)
                {
                    this.m_game.AddAction(new LivingWalkAction(this, path, action, delay, speed, sAction, callback));
                    return true;
                }
            }
            return false;
        }  

        public double Distance(Point p)
        {
            List<double> distances = new List<double>();
            Rectangle rect = GetDirectDemageRect();

            for (int x = rect.X; x <= rect.X + rect.Width; x = x + 10)
            {
                distances.Add(Math.Sqrt((x - p.X) * (x - p.X) + (rect.Y - p.Y) * (rect.Y - p.Y)));
                distances.Add(Math.Sqrt((x - p.X) * (x - p.X) + (rect.Y + rect.Height - p.Y) * (rect.Y + rect.Height - p.Y)));
            }

            for (int y = rect.Y; y <= rect.Y + rect.Height; y = y + 10)
            {
                distances.Add(Math.Sqrt((rect.X - p.X) * (rect.X - p.X) + (y - p.Y) * (y - p.Y)));
                distances.Add(Math.Sqrt((rect.X + rect.Width - p.X) * (rect.X + rect.Width - p.X) + (y - p.Y) * (y - p.Y)));
            }
            return distances.Min();
        }

        public double BoundDistance(Point p)
        {
            List<double> distances = new List<double>();
            foreach (Rectangle rect in GetDirectBoudRect())
            {
                for (int x = rect.X; x <= rect.X + rect.Width; x = x + 10)
                {
                    distances.Add(Math.Sqrt((x - p.X) * (x - p.X) + (rect.Y - p.Y) * (rect.Y - p.Y)));
                    distances.Add(Math.Sqrt((x - p.X) * (x - p.X) + (rect.Y + rect.Height - p.Y) * (rect.Y + rect.Height - p.Y)));
                }

                for (int y = rect.Y; y <= rect.Y + rect.Height; y = y + 10)
                {
                    distances.Add(Math.Sqrt((rect.X - p.X) * (rect.X - p.X) + (y - p.Y) * (y - p.Y)));
                    distances.Add(Math.Sqrt((rect.X + rect.Width - p.X) * (rect.X + rect.Width - p.X) + (y - p.Y) * (y - p.Y)));
                }
            }
            return distances.Min();
        }
        public eLivingType Type
        {
            get { return m_type; }
            set { m_type = value; }
        }

        //保存小怪说话的索引，-1为不说话
        public bool IsSay
        {
            get;
            set;
        }

        public EffectList EffectList
        {
            get { return m_effectList; }
        }

        public virtual void Reset()
        {
            if (NoTakeDamage)
            {
                m_blood = m_maxBlood;
            }
            else
            {
                m_blood = m_maxBlood / 2;
            }

            m_isFrost = false;
            m_isHide = false;
            m_isNoHole = false;
            m_isLiving = true;

            TurnNum = 0;
            TotalHurt = 0;
            TotalKill = 0;
            TotalShootCount = 0;
            TotalHitTargetCount = 0;
        }

        public virtual void PickBox(Box box)
        {
            box.UserID = Id;
            box.Die();

            if (m_syncAtTime)
            {
                m_game.SendGamePickBox(this, box.Id, 0, "");
            }
        }

        public override void PrepareNewTurn()
        {
            ShootMovieDelay = 0;
            CurrentDamagePlus = 1;
            CurrentShootMinus = 1;
            IgnoreArmor = false;
            ControlBall = false;
            NoHoleTurn = false;
            CurrentIsHitTarget = false;
            OnBeginNewTurn();
        }

        public virtual void PrepareSelfTurn()
        {
            OnBeginSelfTurn();
        }

        public void StartAttacked()
        {
            OnStartAttacked();
        }
        #region Normal Actions

        private bool m_isAttacking;

        public bool IsAttacking
        {
            get { return m_isAttacking; }
        }

        public virtual void StartAttacking()
        {
            if (m_isAttacking == false)
            {
                m_isAttacking = true;
                OnStartAttacking();
            }
        }

        public virtual void StopAttacking()
        {
            if (m_isAttacking == true)
            {
                m_isAttacking = false;
                OnStopAttacking();
            }
        }

        public override void CollidedByObject(Physics phy)
        {
            if (phy is SimpleBomb)
            {
                ((SimpleBomb)phy).Bomb();
            }
        }

        public override void StartMoving()
        {
            StartMoving(0, 30);
        }

        public virtual void StartMoving(int delay, int speed)
        {

            if (m_map.IsEmpty(X, Y) && (int)Type != 6 && (int)Type != 1)
            {
                //Console.WriteLine("?????"+m_x,m_y);
                FallFrom(X, Y, null, delay, 0, speed);
            }
            base.StartMoving();
        }

        public void SetXY(int x, int y, int delay)
        {
            m_game.AddAction(new LivingDirectSetXYAction(this, x, y, delay));
        }

        public void AddEffect(AbstractEffect effect, int delay)
        {
            m_game.AddAction(new LivingDelayEffectAction(this, effect, delay));
        }

        public void Say(string msg, int type, int delay, int finishTime)
        {
            m_game.AddAction(new LivingSayAction(this, msg, type, delay, finishTime));
        }

        public void Say(string msg, int type, int delay)
        {
            m_game.AddAction(new LivingSayAction(this, msg, type, delay, 1000));
        }

        protected static int STEP_X = 2;
        protected static int STEP_Y = 7;

        public bool MoveTo(int x, int y, string action, int delay, string sAction, int speed)
        {
            return MoveTo(x, y, action, delay, sAction, speed, null);
        }

        public bool MoveTo(int x, int y, string action, int delay, string sAction, int speed, LivingCallBack callback)
        {
            if (m_x == x && m_y == y)
                return false;

            if (x < 0 || x > m_map.Bound.Width) return false;

            List<Point> path = new List<Point>();

            int tx = m_x;
            int ty = m_y;
            int direction = x > tx ? 1 : -1;
            if (action == "fly")
            {
                Point p = new Point(x, y);
                Point p1 = new Point(tx - p.X, ty - p.Y);

                //while ((x - tx) * direction > 0)
                {
                    //p1 = new Point(3);
                    p = new Point(p.X + p1.X, y + p1.X);
                    p1 = new Point(x - p.X, x - p.Y);
                    if (p != Point.Empty)
                    {
                        //path.Add(p);
                        //Console.WriteLine(">>>>>X: "+p.X+" Y: "+p.Y);
                        //continue;
                    }
                    //p = new Point(tx, ty);
                    p = new Point(x, y);
                    path.Add(p);
                    //break;
                }
            }
            else
            {

                while ((x - tx) * direction > 0)
                {
                    Point p = m_map.FindNextWalkPoint(tx, ty, direction, STEP_X, STEP_Y);
                    if (p != Point.Empty)
                    {
                        //Console.WriteLine(">>>>>X: " + p.X + " Y: " + p.Y);
                        path.Add(p);
                        tx = p.X;
                        ty = p.Y;
                        continue;
                    }
                    break;
                }
            }
            if (path.Count > 0)
            {
                //sAction = sAction == null ? "" : sAction;
                m_game.AddAction(new LivingMoveToAction(this, path, action, delay, speed, sAction, callback));
                return true;
            }
            else
            {
                return false;
            }
        }

        public bool FallFrom(int x, int y, string action, int delay, int type, int speed)
        {
            return FallFrom(x, y, action, delay, type, speed, null);
        }
        public bool FallFrom(int x, int y, string action, int delay, int type, int speed, LivingCallBack callback)
        {
            Point p = m_map.FindYLineNotEmptyPoint(x, y);
            if (p == Point.Empty)
            {
                p = new Point(x, m_game.Map.Bound.Height + 1);
            }
            if (Y < p.Y)
            {
                m_game.AddAction(new LivingFallingAction(this, p.X, p.Y, speed, action, delay, type, callback));

                return true;
            }
            return false;
        }

        public bool JumpTo(int x, int y, string action, int delay, int type)
        {
            return JumpTo(x, y, action, delay, type, 20, null);
        }

        public bool JumpTo(int x, int y, string ation, int delay, int type, LivingCallBack callback)
        {
            return JumpTo(x, y, ation, delay, type, 20, callback);
        }

        public bool JumpTo(int x, int y, string action, int delay, int type, int speed, LivingCallBack callback)
        {

            Point p = m_map.FindYLineNotEmptyPoint(x, y);
            if (p.Y < Y)
            {
                m_game.AddAction(new LivingJumpAction(this, p.X, p.Y, speed, action, delay, type, callback));
                return true;
            }
            return false;
        }

        public void ChangeDirection(int direction, int delay)
        {
            if (delay > 0)
            {
                m_game.AddAction(new LivingChangeDirectionAction(this, direction, delay));
            }
            else
            {
                Direction = direction;
            }
        }

        protected int MakeDamage(Living target)
        {
            double baseDamage = BaseDamage;
            double baseGuard = target.BaseGuard;

            double defence = target.Defence;
            double attack = Attack;
            if (IgnoreArmor)
            {
                baseGuard = 0;
                defence = 0;
            }



            float damagePlus = CurrentDamagePlus;
            float shootMinus = CurrentShootMinus;

            //伤害={ 基础伤害*（1+攻击*0.1%）*[1-（基础护甲/200+防御*0.03%）] }*(1+道具攻击加成）*炸弹威力*连击系数
            // double damage = (baseDamage * ( 1 + attack * 0.001) * (1 - (baseGuard / 200 + defence * 0.003))) * (1 + damagePlus) * shootMinus ;

            double DR1 = 0.95 * (target.BaseGuard - 3 * Grade) / (500 + target.BaseGuard - 3 * Grade);//护甲提供伤害减免
            double DR2 = 0;
            if ((target.Defence - Lucky) < 0)
            {
                DR2 = 0;
            }
            else
            {

                DR2 = 0.95 * (target.Defence - Lucky) / (600 + target.Defence - Lucky); //防御提供的伤害减免
            }
            //DR2 = DR2 < 0 ? 0 : DR2;

            double damage = (baseDamage * (1 + attack * 0.001) * (1 - (DR1 + DR2 - DR1 * DR2))) * damagePlus * shootMinus;
            Point p = new Point(X, Y);
            //double distance = target.Distance(p);
            //Console.WriteLine("");

            if (damage < 0)
            {
                return 1;
            }
            else
            {
                return (int)damage;
            }
        }
        
        public bool Beat(Living target, string action, int demageAmount, int criticalAmount, int delay, int livingCount, int attackEffect)
        {
            if (target == null || target.IsLiving == false)
                return false;

            demageAmount = MakeDamage(target);
            //Console.WriteLine("Living.Beat() : {0}", demageAmount);
            int dis = (int)target.Distance(X, Y);
            if (dis <= MaxBeatDis)   //加了等号
            {
                if (X - target.X > 0)
                {
                    Direction = -1;
                }
                else
                {
                    Direction = 1;
                }
                m_game.AddAction(new LivingBeatAction(this, target, demageAmount, criticalAmount, action, delay, livingCount, attackEffect));
                return true;
            }
            else
            {
                return false;
            }
        }

        public bool RangeAttacking(int fx, int tx, string action, int delay, List<Player> players)
        {
            if (IsLiving)
            {
                m_game.AddAction(new LivingRangeAttackingAction(this, fx, tx, action, delay, players));
                return true;
            }
            return false;
        }

        public void GetShootForceAndAngle(ref int x, ref int y, int bombId, int minTime, int maxTime, int bombCount, float time, ref int force, ref int angle)
        {
            if (minTime >= maxTime)
                return;

            BallInfo ballInfo = BallMgr.FindBall(bombId);
            if (m_game != null && ballInfo != null)
            {
                Map map = m_game.Map;
                Point sp = GetShootPoint();
                float dx = x - sp.X;
                float dy = y - sp.Y;
                float arf = map.airResistance * ballInfo.DragIndex;
                float gf = map.gravity * ballInfo.Weight * ballInfo.Mass;
                float wf = map.wind * ballInfo.Wind;
                float mass = ballInfo.Mass;
                for (float t = time; t <= 4; t += 0.6F)
                {
                    double vx = ComputeVx(dx, mass, arf, wf, t);
                    double vy = ComputeVy(dy, mass, arf, gf, t);

                    if (vy < 0 && vx * m_direction > 0)
                    {
                        double tf = Math.Sqrt(vx * vx + vy * vy);
                        if (tf < 2000)
                        {
                            //Console.WriteLine(string.Format("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< vx:{0}   vy:{1}", vx, vy));
                            force = (int)tf;
                            angle = (int)(Math.Atan(vy / vx) / Math.PI * 180);
                            if (vx < 0)
                            {
                                angle = angle + 180;
                            }
                            break;
                        }
                    }
                }
                x = sp.X;
                y = sp.Y;
            }

        }
        public bool ShootPoint(int x, int y, int bombId, int minTime, int maxTime, int bombCount, float time, int delay)
        {
            m_game.AddAction(new LivingShootAction(this, bombId, x, y, 0, 0, bombCount, minTime, maxTime, time, delay));
            return true;
        }

        public bool IsFriendly(Living living)
        {
            if (living is Player)
                return false;

            if (living.Team == Team)
                return true;
            else
                return false;
        }

        public bool Shoot(int bombId, int x, int y, int force, int angle, int bombCount, int delay)
        {
            m_game.AddAction(new LivingShootAction(this, bombId, x, y, force, angle, bombCount, delay, 0, 0, 0));
            return true;
        }

        public static double ComputeVx(double dx, float m, float af, float f, float t)
        {
            return (dx - f / m * t * t / 2) / t + af / m * dx * 0.7;
        }

        public static double ComputeVy(double dx, float m, float af, float f, float t)
        {
            return (dx - f / m * t * t / 2) / t + af / m * dx * 1.3;
        }

        public static double ComputDX(double v, float m, float af, float f, float dt)
        {
            return v * dt + (f - af * v) / m * dt * dt;
        }
        
        public bool ShootImp(int bombId, int x, int y, int force, int angle, int bombCount, int shootCount)
        {           
            BallInfo ballInfo = BallMgr.FindBall(bombId);
            Tile shape = BallMgr.FindTile(bombId);
            BombType ballType = BallMgr.GetBallType(bombId);
            int _wind = (int)(m_map.wind * 10);
            //BombAction acp = null;
            if (ballInfo != null)//某些炸弹无图
            {
                GSPacketIn pkg = new GSPacketIn((byte)ePackageType.GAME_CMD, Id);
                pkg.Parameter1 = Id;
                pkg.WriteByte((byte)eTankCmdType.FIRE);

                pkg.WriteInt(_wind);
                pkg.WriteBoolean(_wind > 0);
                pkg.WriteByte(m_game.GetVane(_wind, 1));
                pkg.WriteByte(m_game.GetVane(_wind, 2));
                pkg.WriteByte(m_game.GetVane(_wind, 3));
                pkg.WriteInt(bombCount);
                float lifeTime = 0;
                int vx = 0;
                int vy = 0;
                SimpleBomb bomb = null;
                for (int i = 0; i < bombCount; i++)
                {
                    double reforce = 1;
                    int reangle = 0;
                    if (i == 1)
                    {
                        reforce = 0.9;
                        reangle = -5;
                    }
                    else if (i == 2)
                    {
                        reforce = 1.1;
                        reangle = 5;
                    }

                    vx = (int)(force * reforce * Math.Cos((double)(angle + reangle) / 180 * Math.PI));
                    vy = (int)(force * reforce * Math.Sin((double)(angle + reangle) / 180 * Math.PI));                    
                    bomb = new SimpleBomb(m_game.PhysicalId++, ballType, this, m_game, ballInfo, shape, ControlBall);

                    bomb.SetXY(x, y);
                    bomb.setSpeedXY(vx, vy);
                    m_map.AddPhysical(bomb);
                    bomb.StartMoving();

                    pkg.WriteInt(bombCount);//number = _loc_2.readInt();
                    pkg.WriteInt(shootCount);//shootCount = _loc_2.readInt();
                    pkg.WriteBoolean(bomb.DigMap);
                    pkg.WriteInt(bomb.Id);
                    pkg.WriteInt(x);
                    pkg.WriteInt(y);
                    pkg.WriteInt(vx);
                    pkg.WriteInt(vy);
                    pkg.WriteInt(bomb.BallInfo.ID);
                    pkg.WriteString(bomb.BallInfo.FlyingPartical);
                    pkg.WriteInt((bomb.BallInfo.Radii * 1000) / 4);//trminhpc
                    pkg.WriteInt((int)bomb.BallInfo.Power * 1000);//trminhpc
                    pkg.WriteInt(bomb.Actions.Count);
                    foreach (BombAction ac in bomb.Actions)
                    {                       
                        pkg.WriteInt(ac.TimeInt);
                        pkg.WriteInt(ac.Type);
                        pkg.WriteInt(ac.Param1);
                        pkg.WriteInt(ac.Param2);
                        pkg.WriteInt(ac.Param3);
                        pkg.WriteInt(ac.Param4);

                    }
                    lifeTime = Math.Max(lifeTime, bomb.LifeTime);
                    
                }
                int petShootCount = bomb.PetActions.Count;
                if (petShootCount > 0 && PetBaseAtt > 0)
                {
                    pkg.WriteInt(petShootCount);//Actions.Count
                    foreach (BombAction acp in bomb.PetActions)
                    {
                        pkg.WriteInt(acp.Param1);//_loc_27 = _loc_2.readInt();//target
                        pkg.WriteInt(acp.Param2);//_loc_29 = _loc_2.readInt//damage
                        pkg.WriteInt(acp.Param4);//_loc_30 = _loc_2.readInt();//hp
                        pkg.WriteInt(acp.Param3);//_loc_31 = _loc_2.readInt();//dander
                    }
                    pkg.WriteInt(1);//_loc_2.readInt();//attackid    
                }
                else
                {
                    pkg.WriteInt(0);
                    pkg.WriteInt(0);              
                }
                //Console.WriteLine("????team: " + Team);
                m_game.SendToAll(pkg);
                m_game.WaitTime((int)((lifeTime + 4 + bombCount / 3) * 1000));
                //tempLivings.Clear();
                return true;
            }

            return false;
        }

        public void PlayMovie(string action, int delay, int MovieTime)
        {
            m_game.AddAction(new LivingPlayeMovieAction(this, action, delay, MovieTime));
            
        }
        public void PlayMovie(string action, int delay, int MovieTime,LivingCallBack call)
        {
            m_game.AddAction(new LivingPlayeMovieAction(this, action, delay, MovieTime));
            
        }
        #endregion

        #region Fighting Properties       
        //private Dictionary<int, Living> m_tempLivings = new Dictionary<int, Living>();
        //public Dictionary<int, Living> tempLivings
        //{
        //    get
        //    {
        //        return m_tempLivings;
        //    }
        //}
        private bool m_isFrost;
        private bool m_isHide;
        private bool m_isNoHole;
        private bool m_isSeal;

        public bool IsFrost
        {
            get { return m_isFrost; }
            set
            {
                if (m_isFrost != value)
                {
                    m_isFrost = value;
                    if (m_syncAtTime)
                    {
                        m_game.SendGameUpdateFrozenState(this);
                    }
                }
            }
        }

        public bool IsNoHole
        {
            get { return m_isNoHole; }
            set
            {
                if (m_isNoHole != value)
                {
                    m_isNoHole = value;
                    if (m_syncAtTime)
                    {
                        m_game.SendGameUpdateNoHoleState(this);
                    }
                }
            }
        }

        public bool IsHide
        {
            get { return m_isHide; }
            set
            {
                if (m_isHide != value)
                {
                    m_isHide = value;
                    if (m_syncAtTime)
                    {
                        m_game.SendGameUpdateHideState(this);
                    }
                }
            }
        }
        /*
        public void SetSeal(bool state, int type)
        {
            if (m_isSeal != state)
            {
                m_isSeal = state;
                if (m_syncAtTime)
                {
                    m_game.SendGameUpdateSealState(this, type);
                }
            }

        }
        */

        public bool GetSealState()
        {
            return m_isSeal;
        }
        public int State
        {
            get { return m_state; }
            set
            {
                if (m_state != value)
                {
                    m_state = value;
                    if (m_syncAtTime)
                    {
                        m_game.SendLivingUpdateAngryState(this);
                    }
                }
            }
        }

        public void Seal(Player player, int type, int delay)
        {
            m_game.AddAction(new LivingSealAction(this, player, type, delay));
        }

        #endregion

        #region Blood/AddBlood/TakeDamage

        public int MaxBlood
        {
            get { return m_maxBlood; }
            //set { m_maxBlood = value; }
        }

        public int Blood
        {
            get { return m_blood; }

            set { m_blood = value; }
        }

        public virtual int AddBlood(int value)
        {
            m_blood += value;
            if (m_blood > m_maxBlood)
            {
                // value = value + m_maxBlood - m_blood;
                m_blood = m_maxBlood;
            }
            if (m_syncAtTime)
            {
                m_game.SendGameUpdateHealth(this, 0, value);
            }

            return value;

        }
        public virtual bool TakeDamage(Living source, ref int damageAmount, ref int criticalAmount, string msg)
        {
            if (!NoTakeDamage && this is SimpleNpc)
            {
                return false;
            }
            bool result = false;

            if (IsFrost == false && m_blood > 0)
            {
                if (source != this || source.Team == Team)
                    OnBeforeTakedDamage(source, ref damageAmount, ref criticalAmount);

                m_blood -= (damageAmount + criticalAmount);

                if (EffectTrigger && this is Player)
                {
                    Game.SendMessage((this as Player).PlayerDetail, LanguageMgr.GetTranslation("PlayerEquipEffect.Success2"), LanguageMgr.GetTranslation("PlayerEquipEffect.Success3", (this as Player).PlayerDetail.PlayerCharacter.NickName), 3);
                }
                if (m_syncAtTime)
                {
                    //if (this is SimpleBoss && (((SimpleBoss)this).NpcInfo.ID == 22 || ((SimpleBoss)this).NpcInfo.ID == 29))
                    //{
                    //    m_game.SendGameUpdateHealth(this, 6, damageAmount + criticalAmount);
                    //}
                    //else
                    //{
                        m_game.SendGameUpdateHealth(this, 6, damageAmount + criticalAmount);//1
                    //}
                }
                OnAfterTakedDamage(source, damageAmount, criticalAmount);

                if (m_blood <= 0)
                {
                    Die();
                }
                //log.Error(string.Format("调用函数" + msg + string.Format("----玩家名称:{0},ID{1}", Name, Id) + string.Format("----当前血量{0}", Blood)));
                if (this is Player)
                {
                    //Console.WriteLine("伤血{0}", damageAmount + criticalAmount);
                    // Console.WriteLine("玩家{0}, 血量{1}", Name, Blood);
                }
                result = true;
            }

            EffectList.StopEffect(typeof(IceFronzeEffect));
            EffectList.StopEffect(typeof(HideEffect));
            EffectList.StopEffect(typeof(NoHoleEffect));

            return result;
        }
        public virtual bool PetTakeDamage(Living source, ref int damageAmount, ref int criticalAmount, string msg)
        {
            if (!NoTakeDamage && this is SimpleNpc)
            {
                return false;
            }
            bool result = false;

            if (m_blood > 0)
            {
                if (source != this || source.Team == Team)
                    OnBeforeTakedDamage(source, ref damageAmount, ref criticalAmount);

                m_blood -= (damageAmount + criticalAmount);                
                OnAfterTakedDamage(source, damageAmount, criticalAmount);
                if (m_blood <= 0)
                {
                    Die();
                }
                
                result = true;
            }
            EffectList.StopEffect(typeof(IceFronzeEffect));
            EffectList.StopEffect(typeof(HideEffect));
            EffectList.StopEffect(typeof(NoHoleEffect));
            return result;
        }


        public virtual void Die(int delay)
        {
            if (IsLiving && m_game != null)
            {
                m_game.AddAction(new LivingDieAction(this, delay));
            }
        }

        public override void Die()
        {
            if (m_blood > 0)
            {
                m_blood = 0;
                if (m_syncAtTime)
                {
                    m_game.SendGameUpdateHealth(this, 6, 0);
                }
            }

            if (IsLiving)
            {
                if (IsAttacking)
                {
                    StopAttacking();
                }

                base.Die();
                OnDied();

                m_game.CheckState(0);
            }
        }

        #endregion

        #region Events

        public event LivingEventHandle Died;
        public event LivingTakedDamageEventHandle BeforeTakeDamage;
        public event LivingTakedDamageEventHandle TakePlayerDamage;
        public event LivingEventHandle BeginNextTurn;
        public event LivingEventHandle BeginSelfTurn;
        public event LivingEventHandle BeginAttacking;
        public event LivingEventHandle BeginAttacked;
        public event LivingEventHandle EndAttacking;
        public event KillLivingEventHanlde AfterKillingLiving;
        public event KillLivingEventHanlde AfterKilledByLiving;

        protected void OnDied()
        {
            if (Died != null) Died(this);
            if (this is Player && Game is PVEGame)
            {
                ((PVEGame)Game).DoOther();
            }
        }

        protected void OnBeforeTakedDamage(Living source, ref int damageAmount, ref int criticalAmount)
        {
            if (BeforeTakeDamage != null)
                BeforeTakeDamage(this, source, ref damageAmount, ref criticalAmount);
        }

        public void OnTakedDamage(Living source, ref int damageAmount, ref int criticalAmount)
        {
            if (TakePlayerDamage != null)
                TakePlayerDamage(this, source, ref damageAmount, ref criticalAmount);
        }

        protected void OnBeginNewTurn()
        {
            if (BeginNextTurn != null) BeginNextTurn(this);
        }

        protected void OnBeginSelfTurn()
        {
            if (BeginSelfTurn != null) BeginSelfTurn(this);
        }

        protected void OnStartAttacked()
        {
            if (BeginAttacked != null) BeginAttacked(this);
        }

        protected void OnStartAttacking()
        {
            if (BeginAttacking != null) BeginAttacking(this);
        }

        protected void OnStopAttacking()
        {
            if (EndAttacking != null) EndAttacking(this);
        }
        public bool Bay(int x, int y, string action, int delay, string sAction, int speed)
        {
            return this.Bay(x, y, action, delay, sAction, speed, null);
        }

        public bool Bay(int x, int y, string action, int delay, string sAction, int speed, LivingCallBack callback)
        {
            if ((base.m_x != x) || (base.m_y != y))
            {
                if ((x < 0) || (x > base.m_map.Bound.Width))
                {
                    return false;
                }
                List<Point> path = new List<Point>();
                int num = base.m_x;
                int num2 = base.m_y;
                int direction = (x > num) ? 1 : -1;
                if (!(action == "fly"))
                {
                    while (((x - num) * direction) > 0)
                    {
                        Point item = base.m_map.FindNextWalkPoint(num, num2, direction, STEP_X, STEP_Y);
                        if (!(item != Point.Empty))
                        {
                            break;
                        }
                        path.Add(item);
                        num = item.X;
                        num2 = item.Y;
                    }
                }
                else
                {
                    Point point = new Point(x, y);
                    Point point2 = new Point(num - point.X, num2 - point.Y);
                    point = new Point(point.X + point2.X, y + point2.X);
                    point2 = new Point(x - point.X, x - point.Y);
                    bool flag1 = point != Point.Empty;
                    point = new Point(x, y);
                    path.Add(point);
                }
                if (path.Count > 0)
                {
                    this.m_game.AddAction(new LivingMoveToAction(this, path, action, delay, speed, sAction, callback));
                    return true;
                }
            }
            return false;
        }

     

        public virtual void OnAfterKillingLiving(Living target, int damageAmount, int criticalAmount)
        {
            if (target.Team != Team)
            {
                CurrentIsHitTarget = true;
                TotalHurt += (damageAmount + criticalAmount);
                if (target.IsLiving == false)
                    TotalKill++;
                m_game.CurrentTurnTotalDamage = damageAmount + criticalAmount;
                m_game.TotalHurt += (damageAmount + criticalAmount);
            }
            if (AfterKillingLiving != null)
                AfterKillingLiving(this, target, damageAmount, criticalAmount);
        }

        public void OnAfterTakedDamage(Living target, int damageAmount, int criticalAmount)
        {
            if (AfterKilledByLiving != null)
                AfterKilledByLiving(this, target, damageAmount, criticalAmount);
        }
        #endregion
  //      public bool FlyTo(int X, int Y, int x, int y, string action, int delay, int speed, LivingCallBack callback)
    //    {
      //      m_game.AddAction(new LivingFlyToAction(this, X, Y, x, y, action, delay, speed, callback));
        //    return true;
        //}
        public bool FlyTo(int x, int y, string action, int delay, int speed)
        {
            return FlyTo(x, y, action, delay, speed, null);
        }
        public bool JumpToSpeed(int x, int y, string action, int delay, int type, int speed, LivingCallBack callback)
        {
            Point point = this.m_map.FindYLineNotEmptyPoint(x, y);
            int arg_15_0 = point.Y;
            this.m_game.AddAction(new LivingJumpAction(this, point.X, point.Y, speed, action, delay, type, callback));
            return true;
        }
        public bool FlyTo(int x, int y, string action, int delay, int speed, LivingCallBack callback)
        {
            m_game.AddAction(new LivingFlyToAction(this, this.X, this.Y, x, y, action, delay, speed, callback));
            m_game.AddAction(new LivingFallingAction(this, x, y, 0, action, delay, 0, callback));
            return true;
        }

        #region Lua
        public void CallFuction(LivingCallBack func, int delay)
        {
            if (m_game != null)
            {
                m_game.AddAction(new LivingCallFunctionAction(this, func, delay));
            }
        }


    }
        #endregion


    public delegate void LivingCallBack();
    public delegate void LivingEventHandle(Living living);
    public delegate void LivingTakedDamageEventHandle(Living living, Living source, ref int damageAmount, ref int criticalAmount);
    public delegate void KillLivingEventHanlde(Living living, Living target, int damageAmount, int criticalAmount);
}
