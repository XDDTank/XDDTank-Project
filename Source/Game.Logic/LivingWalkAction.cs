using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Logic.Phy.Object;
using System.Drawing;

namespace Game.Logic.Actions
{
    public class LivingWalkAction : BaseAction
    {
        private string m_action;

        private LivingCallBack m_callback;

        private int m_index;

        private bool m_isSent;

        private Living m_living;

        private List<Point> m_path;

        private string m_saction;

        private int m_speed;

        public LivingWalkAction(Living living, List<Point> path, string action, int delay, int speed, string sAction, LivingCallBack callback)
            : base(delay, 0)
        {
            this.m_living = living;
            this.m_path = path;
            this.m_action = action;
            this.m_saction = sAction;
            this.m_isSent = false;
            this.m_index = 0;
            this.m_callback = callback;
            this.m_speed = speed;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
            if (!this.m_isSent)
            {
                this.m_isSent = true;
                Point point = this.m_path[this.m_path.Count - 1];
                Point point2 = this.m_path[this.m_path.Count - 1];
                game.SendLivingWalk(this.m_living, this.m_living.X, this.m_living.Y, point.X, point2.Y, this.m_action, this.m_speed, this.m_saction);
            }
            this.m_index++;
            if (this.m_index >= this.m_path.Count)
            {
                Point point3 = this.m_path[this.m_index - 1];
                if (point3.X > this.m_living.X)
                {
                    this.m_living.Direction = 1;
                }
                else
                {
                    this.m_living.Direction = -1;
                }
                Point point4 = this.m_path[this.m_index - 1];
                Point point5 = this.m_path[this.m_index - 1];
                this.m_living.SetXY(point4.X, point5.Y);
                if (this.m_callback != null)
                {
                    this.m_living.CallFuction(this.m_callback, 0);
                }
                base.Finish(tick);
            }
        }
    }
}