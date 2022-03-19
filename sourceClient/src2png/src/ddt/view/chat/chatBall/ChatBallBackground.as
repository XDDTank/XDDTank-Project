// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.chat.chatBall.ChatBallBackground

package ddt.view.chat.chatBall
{
    import flash.display.MovieClip;
    import flash.geom.Rectangle;
    import flash.geom.Point;

    public class ChatBallBackground extends MovieClip 
    {

        private var paopaomc:MovieClip;
        private var _baseTextArea:Rectangle;
        private var _scale:Number;
        private var _direction:Point;

        public function ChatBallBackground(_arg_1:MovieClip)
        {
            this._scale = 1;
            this.paopaomc = _arg_1;
            addChild(this.paopaomc);
            this.paopaomc.bg.rtTopPoint.parent.removeChild(this.paopaomc.bg.rtTopPoint);
            this._baseTextArea = new Rectangle(this.paopaomc.bg.rtTopPoint.x, this.paopaomc.bg.rtTopPoint.y, this.paopaomc.bg.rtTopPoint.width, this.paopaomc.bg.rtTopPoint.height);
            this.direction = new Point(-1, -1);
        }

        public function fitSize(_arg_1:Point):void
        {
            var _local_2:Number = (_arg_1.x / this._baseTextArea.width);
            var _local_3:Number = (_arg_1.y / this._baseTextArea.height);
            if (_local_2 > _local_3)
            {
                this.scale = _local_2;
            }
            else
            {
                this.scale = _local_3;
            };
            this.update();
        }

        public function set direction(_arg_1:Point):void
        {
            if (x == 0)
            {
                x = -1;
            };
            if (y == 0)
            {
                y = -1;
            };
            if (this._direction == _arg_1)
            {
                return;
            };
            this._direction = _arg_1;
            if (this._direction == null)
            {
                return;
            };
            if (this._direction.x > 0)
            {
                this.paopaomc.scaleX = -(this._scale);
            }
            else
            {
                this.paopaomc.scaleX = this._scale;
            };
            if (this._direction.y > 0)
            {
                this.paopaomc.scaleY = -(this._scale);
            }
            else
            {
                this.paopaomc.scaleY = this._scale;
            };
            this.update();
        }

        public function get direction():Point
        {
            return (this._direction);
        }

        protected function set scale(_arg_1:Number):void
        {
            if (this._scale == _arg_1)
            {
                return;
            };
            this._scale = _arg_1;
            if (this.paopaomc.scaleX > 0)
            {
                this.paopaomc.scaleX = _arg_1;
            }
            else
            {
                this.paopaomc.scaleX = -(_arg_1);
            };
            if (this.paopaomc.scaleY > 0)
            {
                this.paopaomc.scaleY = _arg_1;
            }
            else
            {
                this.paopaomc.scaleY = -(_arg_1);
            };
            this.update();
        }

        protected function get scale():Number
        {
            return (this._scale);
        }

        public function get textArea():Rectangle
        {
            var _local_1:Rectangle = new Rectangle();
            if (this.paopaomc.scaleX > 0)
            {
                _local_1.x = (this._baseTextArea.x * this.scale);
            }
            else
            {
                _local_1.x = (-(this._baseTextArea.right) * this.scale);
            };
            if (this.paopaomc.scaleY > 0)
            {
                _local_1.y = (this._baseTextArea.y * this.scale);
            }
            else
            {
                _local_1.y = (-(this._baseTextArea.bottom) * this.scale);
            };
            _local_1.width = (this._baseTextArea.width * Math.abs(this.scale));
            _local_1.height = (this._baseTextArea.height * Math.abs(this.scale));
            return (_local_1);
        }

        public function drawTextArea():void
        {
        }

        private function update():void
        {
        }

        public function dispose():void
        {
            this._baseTextArea = null;
            this.paopaomc = null;
        }


    }
}//package ddt.view.chat.chatBall

