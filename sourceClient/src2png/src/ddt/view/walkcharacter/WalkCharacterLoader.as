// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.walkcharacter.WalkCharacterLoader

package ddt.view.walkcharacter
{
    import flash.events.EventDispatcher;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.BitmapData;
    import __AS3__.vec.Vector;
    import ddt.data.player.PlayerInfo;
    import ddt.manager.ItemManager;
    import ddt.view.character.ILayer;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import com.pickgliss.utils.DisplayUtils;
    import flash.events.Event;
    import __AS3__.vec.*;

    public class WalkCharacterLoader extends EventDispatcher implements Disposeable 
    {

        public static const CellCharaterWidth:int = 120;
        public static const CellCharaterHeight:int = 175;
        private static const standFrams:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1];
        private static const backFrame:Array = [3];
        private static const walkFrontFrame:Array = [3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6, 7, 7, 7, 8, 8, 8];
        private static const walkBackFrame:Array = [10, 10, 10, 11, 11, 11, 12, 12, 12, 13, 13, 13, 14, 14, 14];
        public static const FrameLabels:Array = [{
            "frame":1,
            "name":"stand"
        }, {
            "frame":(standFrams.length - 1),
            "name":"gotoAndPlay(stand)"
        }, {
            "frame":standFrams.length,
            "name":"back"
        }, {
            "frame":(standFrams.length + backFrame.length),
            "name":"walkfront"
        }, {
            "frame":(((standFrams.length + backFrame.length) + walkFrontFrame.length) - 1),
            "name":"gotoAndPlay(walkfront)"
        }, {
            "frame":((standFrams.length + backFrame.length) + walkFrontFrame.length),
            "name":"walkback"
        }, {
            "frame":((((standFrams.length + backFrame.length) + walkFrontFrame.length) + walkBackFrame.length) - 1),
            "name":"gotoAndPlay(walkback)"
        }];
        public static const UsedFrame:Array = standFrams.concat(backFrame, walkFrontFrame, walkBackFrame);
        public static const Stand:String = "stand";
        public static const Back:String = "back";
        public static const WalkFront:String = "walkfront";
        public static const WalkBack:String = "walkback";

        private var _resultBitmapData:BitmapData;
        private var _layers:Vector.<WalkCharaterLayer>;
        private var _playerInfo:PlayerInfo;
        private var _recordStyle:Array;
        private var _recordColor:Array;
        private var _clothPath:String;

        public function WalkCharacterLoader(_arg_1:PlayerInfo, _arg_2:String)
        {
            this._clothPath = _arg_2;
            this._playerInfo = _arg_1;
        }

        public function load():void
        {
            this._layers = new Vector.<WalkCharaterLayer>();
            if (((this._playerInfo == null) || (this._playerInfo.Style == null)))
            {
                return;
            };
            this.initLoaders();
            var _local_1:int = this._layers.length;
            var _local_2:int;
            while (_local_2 < _local_1)
            {
                this._layers[_local_2].load(this.layerComplete);
                _local_2++;
            };
        }

        private function initLoaders():void
        {
            this._layers = new Vector.<WalkCharaterLayer>();
            this._recordStyle = this._playerInfo.Style.split(",");
            this._recordColor = this._playerInfo.Colors.split(",");
            this._layers.push(new WalkCharaterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[5].split("|")[0])), this._recordColor[5]));
            this._layers.push(new WalkCharaterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[2].split("|")[0])), this._recordColor[2]));
            this._layers.push(new WalkCharaterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[3].split("|")[0])), this._recordColor[3]));
            this._layers.push(new WalkCharaterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[4].split("|")[0])), this._recordColor[4], 1, this._playerInfo.Sex, this._clothPath));
            this._layers.push(new WalkCharaterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[4].split("|")[0])), this._recordColor[4], 2, this._playerInfo.Sex, this._clothPath));
        }

        private function layerComplete(_arg_1:ILayer):void
        {
            var _local_2:Boolean = true;
            var _local_3:int;
            while (_local_3 < this._layers.length)
            {
                if ((!(this._layers[_local_3].isComplete)))
                {
                    _local_2 = false;
                };
                _local_3++;
            };
            if (_local_2)
            {
                this.loadComplete();
            };
        }

        private function loadComplete():void
        {
            var eff:BitmapData;
            var face:BitmapData;
            var hair:BitmapData;
            var clothFront:BitmapData;
            var clothBack:BitmapData;
            var drawFrame:Function = function (_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int=0):void
            {
                var _local_7:Rectangle = new Rectangle();
                _local_7.width = CellCharaterWidth;
                _local_7.height = CellCharaterHeight;
                var _local_8:Point = new Point();
                _local_8.x = (_arg_1 * CellCharaterWidth);
                if (_arg_2 <= 6)
                {
                    _local_7.x = (_arg_4 * CellCharaterWidth);
                    _local_7.y = 0;
                    _local_8.y = _arg_6;
                    _resultBitmapData.copyPixels(face, _local_7, _local_8, null, null, true);
                    _local_7.x = (_arg_3 * CellCharaterWidth);
                    _resultBitmapData.copyPixels(hair, _local_7, _local_8, null, null, true);
                    _local_7.x = (_arg_5 * CellCharaterWidth);
                    _resultBitmapData.copyPixels(eff, _local_7, _local_8, null, null, true);
                    _local_7.x = (_arg_2 * CellCharaterWidth);
                    _local_8.y = 0;
                    _resultBitmapData.copyPixels(clothFront, _local_7, _local_8, null, null, true);
                }
                else
                {
                    _local_7.x = ((_arg_2 - 7) * CellCharaterWidth);
                    _local_7.y = CellCharaterHeight;
                    _resultBitmapData.copyPixels(clothBack, _local_7, _local_8, null, null, true);
                    _local_7.x = (_arg_4 * CellCharaterWidth);
                    _local_7.y = 0;
                    _local_8.y = _arg_6;
                    _resultBitmapData.copyPixels(face, _local_7, _local_8, null, null, true);
                    _local_7.x = (_arg_3 * CellCharaterWidth);
                    _resultBitmapData.copyPixels(hair, _local_7, _local_8, null, null, true);
                    _local_7.x = (_arg_5 * CellCharaterWidth);
                    _resultBitmapData.copyPixels(eff, _local_7, _local_8, null, null, true);
                };
            };
            eff = DisplayUtils.getDisplayBitmapData(this._layers[2]);
            face = DisplayUtils.getDisplayBitmapData(this._layers[0]);
            hair = DisplayUtils.getDisplayBitmapData(this._layers[1]);
            clothFront = DisplayUtils.getDisplayBitmapData(this._layers[3]);
            clothBack = DisplayUtils.getDisplayBitmapData(this._layers[4]);
            this._resultBitmapData = new BitmapData((CellCharaterWidth * 15), CellCharaterHeight, true, 0xFF0000);
            (drawFrame(0, 0, 0, 0, 0));
            (drawFrame(1, 0, 1, 1, 1));
            (drawFrame(2, 7, 2, 2, 2));
            (drawFrame(3, 1, 0, 0, 0));
            (drawFrame(4, 2, 0, 0, 0));
            (drawFrame(5, 3, 0, 0, 0, 2));
            (drawFrame(6, 4, 0, 0, 0));
            (drawFrame(7, 5, 0, 0, 0));
            (drawFrame(8, 6, 0, 0, 0, 2));
            (drawFrame(9, 8, 2, 2, 2));
            (drawFrame(10, 9, 2, 2, 2));
            (drawFrame(11, 10, 2, 2, 2, 2));
            (drawFrame(12, 11, 2, 2, 2));
            (drawFrame(13, 12, 2, 2, 2));
            (drawFrame(14, 13, 2, 2, 2, 2));
            dispatchEvent(new Event(Event.COMPLETE));
        }

        public function get content():BitmapData
        {
            return (this._resultBitmapData);
        }

        public function dispose():void
        {
            this._resultBitmapData.dispose();
            var _local_1:int;
            while (_local_1 < this._layers.length)
            {
                this._layers[_local_1].dispose();
                _local_1++;
            };
            this._layers = null;
            this._recordStyle = null;
            this._recordColor = null;
            this._playerInfo = null;
        }


    }
}//package ddt.view.walkcharacter

