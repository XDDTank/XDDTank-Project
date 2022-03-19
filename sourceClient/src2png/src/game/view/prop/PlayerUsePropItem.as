// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.prop.PlayerUsePropItem

package game.view.prop
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import game.model.Player;
    import game.view.playerThumbnail.PlayerThumbItem;
    import __AS3__.vec.Vector;
    import bagAndInfo.bag.ItemCellView;
    import com.greensock.TimelineMax;
    import com.pickgliss.ui.ComponentFactory;
    import com.greensock.TweenMax;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class PlayerUsePropItem extends Sprite implements Disposeable 
    {

        private var _info:Player;
        private var _headFigure:PlayerThumbItem;
        private var _itemCellList:Vector.<ItemCellView>;
        private var _width:int;
        private var _timeLine:TimelineMax;

        public function PlayerUsePropItem(_arg_1:Player)
        {
            this._info = _arg_1;
            this.init();
        }

        protected function init():void
        {
            this._headFigure = ComponentFactory.Instance.creat("game.view.prop.PlayerUsePropItem.headFigure", [this._info]);
            if (this._info.isLiving)
            {
                this._headFigure.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            };
            addChild(this._headFigure);
            this._width = (this._width + 5);
            this._itemCellList = new Vector.<ItemCellView>();
            this._timeLine = new TimelineMax();
        }

        public function start():void
        {
            this._headFigure.alpha = 0;
            this._headFigure.x = this._headFigure.width;
            this._width = (this._headFigure.width + 5);
            var _local_1:TweenMax = TweenMax.to(this._headFigure, 0.25, {
                "x":0,
                "alpha":1,
                "glowFilter":{
                    "color":16777164,
                    "blurX":50,
                    "blurY":50
                },
                "colorMatrixFilter":{"brightness":2}
            });
            var _local_2:TweenMax = TweenMax.to(this._headFigure, 0.25, {
                "x":0,
                "alpha":1,
                "glowFilter":{
                    "color":16777164,
                    "blurX":0,
                    "blurY":0
                },
                "colorMatrixFilter":{"brightness":1}
            });
            this._timeLine.append(_local_1);
            this._timeLine.append(_local_2);
            this._timeLine.play();
        }

        public function addProp(_arg_1:DisplayObject):void
        {
            var _local_2:ItemCellView;
            _local_2 = new ItemCellView(0, _arg_1);
            _local_2.alpha = 0;
            _local_2.x = (this._width + _local_2.width);
            addChild(_local_2);
            this._itemCellList.push(_local_2);
            this._timeLine.append(TweenMax.to(_local_2, 0.1, {
                "x":this._width,
                "alpha":1,
                "colorMatrixFilter":{"brightness":2.4}
            }));
            this._timeLine.append(TweenMax.to(_local_2, 0.1, {"colorMatrixFilter":{"brightness":1}}));
            this._timeLine.play();
            this._width = ((this._width + _local_2.width) + 5);
        }

        public function dispose():void
        {
            this._timeLine.kill();
            this._timeLine = null;
            ObjectUtils.disposeObject(this._headFigure);
            this._headFigure = null;
            while (this._itemCellList.length > 0)
            {
                ObjectUtils.disposeObject(this._itemCellList.shift());
            };
            this._itemCellList = null;
            this._info = null;
        }


    }
}//package game.view.prop

