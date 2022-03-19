// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.playerThumbnail.HeadFigure

package game.view.playerThumbnail
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import game.model.Player;
    import game.model.Living;
    import flash.display.MovieClip;
    import flash.events.Event;
    import com.pickgliss.utils.ClassUtils;
    import com.pickgliss.utils.ObjectUtils;
    import flash.display.BitmapData;
    import flash.display.PixelSnapping;
    import flash.geom.Rectangle;
    import flash.geom.Matrix;
    import game.model.SimpleBoss;
    import flash.filters.ColorMatrixFilter;

    public class HeadFigure extends Sprite implements Disposeable 
    {

        public static const HEAD_WIDTH:int = 36;
        public static const HEAD_HEIGHT:int = 36;

        private var _head:Bitmap;
        private var _info:Player;
        private var _width:Number;
        private var _height:Number;
        private var _living:Living;
        private var _isGray:Boolean = false;
        private var _defaultBody:MovieClip;

        public function HeadFigure(_arg_1:Number, _arg_2:Number, _arg_3:Object=null)
        {
            if ((_arg_3 is Player))
            {
                this._info = (_arg_3 as Player);
                if (((this._info) && (this._info.character)))
                {
                    this._info.character.addEventListener(Event.COMPLETE, this.bitmapChange);
                };
            }
            else
            {
                this._living = (_arg_3 as Living);
                this._living.addEventListener(Event.COMPLETE, this.bitmapChange);
            };
            this._width = _arg_1;
            this._height = _arg_2;
            this.initFigure();
            this.width = _arg_1;
            this.height = _arg_2;
        }

        private function initFigure():void
        {
            if (((this._living) && (this._living.thumbnail)))
            {
                this._head = new Bitmap(this._living.thumbnail.clone(), "auto", true);
                addChild(this._head);
            }
            else
            {
                if ((((this._info) && (this._info.character)) && (this._info.character.completed)))
                {
                    this.drawHead(this._info.character.characterBitmapdata);
                    addChild(this._head);
                }
                else
                {
                    this._defaultBody = (ClassUtils.CreatInstance("asset.game.bodyDefaultPlayer") as MovieClip);
                    this._defaultBody.x = 29;
                    this._defaultBody.y = 45;
                    addChild(this._defaultBody);
                };
            };
        }

        private function bitmapChange(_arg_1:Event):void
        {
            if (this._defaultBody)
            {
                ObjectUtils.disposeObject(this._defaultBody);
                this._defaultBody = null;
            };
            if (this._living)
            {
                this._head = new Bitmap(this._living.thumbnail.clone(), "auto", true);
                addChild(this._head);
                width = this._width;
                height = this._height;
            }
            else
            {
                if (((!(this._info)) || (!(this._info.character))))
                {
                    return;
                };
                if ((((this._info) && (this._info.character)) && (this._info.character.completed)))
                {
                    this.drawHead(this._info.character.characterBitmapdata);
                    addChild(this._head);
                };
            };
            if (this._isGray)
            {
                this.gray();
            };
        }

        private function drawHead(_arg_1:BitmapData):void
        {
            if (_arg_1 == null)
            {
                return;
            };
            if (this._head)
            {
                if (this._head.parent)
                {
                    this._head.parent.removeChild(this._head);
                };
                this._head.bitmapData.dispose();
                this._head = null;
            };
            this._head = new Bitmap(new BitmapData(this._width, this._height, true, 0), PixelSnapping.AUTO, true);
            var _local_2:Rectangle = this.getHeadRect();
            var _local_3:Matrix = new Matrix();
            _local_3.identity();
            _local_3.scale((this._width / _local_2.width), (this._height / _local_2.height));
            _local_3.translate((-(_local_2.x) * (this._width / _local_2.width)), (-(_local_2.y) * (this._height / _local_2.height)));
            this._head.bitmapData.draw(_arg_1, _local_3);
            addChild(this._head);
        }

        private function getHeadRect():Rectangle
        {
            if (this._info == null)
            {
                if ((this._living is SimpleBoss))
                {
                    return (new Rectangle(0, 0, 200, 200));
                };
                return (new Rectangle(-2, -2, 80, 80));
            };
            if (this._info.playerInfo.getSuitsType() == 1)
            {
                return (new Rectangle(21, 12, 167, 165));
            };
            return (new Rectangle(16, 58, 170, 170));
        }

        public function gray():void
        {
            if (this._head)
            {
                this._head.filters = [new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0])];
            };
            this._isGray = true;
        }

        public function dispose():void
        {
            if (this._info)
            {
                if (this._info.character)
                {
                    this._info.character.removeEventListener(Event.COMPLETE, this.bitmapChange);
                };
            };
            if (this._living)
            {
                this._living.removeEventListener(Event.COMPLETE, this.bitmapChange);
            };
            if (this._head)
            {
                if (this._head.parent)
                {
                    this._head.parent.removeChild(this._head);
                };
                this._head.bitmapData.dispose();
                this._head = null;
            };
            this._living = null;
            this._head = null;
            this._info = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view.playerThumbnail

