﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.MouseStateTxtPower

package game.view
{
    import flash.display.MovieClip;

    public class MouseStateTxtPower extends MovieClip 
    {

        public var num1:MovieClip;
        public var num2:MovieClip;
        public var num3:MovieClip;

        public function MouseStateTxtPower()
        {
            stop();
        }

        public function setNum(_arg_1:int):void
        {
            var _local_2:int;
            _arg_1 = Math.abs(_arg_1);
            _local_2 = int((_arg_1 / 100));
            var _local_3:int = int(((_arg_1 % 100) / 10));
            var _local_4:int = ((_arg_1 % 100) % 10);
            if (_local_2 == 0)
            {
                this.num3.visible = false;
                if (_local_3 == 0)
                {
                    this.num2.visible = false;
                    this.num1.gotoAndStop((_local_4 + 1));
                }
                else
                {
                    this.num2.visible = true;
                    this.num2.gotoAndStop((_local_4 + 1));
                    this.num1.gotoAndStop((_local_3 + 1));
                };
            }
            else
            {
                this.num3.visible = true;
                this.num2.visible = true;
                this.num3.gotoAndStop((_local_4 + 1));
                this.num2.gotoAndStop((_local_3 + 1));
                this.num1.gotoAndStop((_local_2 + 1));
            };
        }


    }
}//package game.view
