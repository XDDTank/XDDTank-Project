// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.player.WalkMapPlayerBase

package SingleDungeon.player
{
    import ddt.view.sceneCharacter.SceneCharacterPlayerBase;
    import ddt.data.player.PlayerInfo;
    import ddt.view.sceneCharacter.SceneCharacterStateSet;
    import ddt.view.sceneCharacter.SceneCharacterSet;
    import ddt.view.sceneCharacter.SceneCharacterActionSet;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import ddt.view.sceneCharacter.SceneCharacterLoaderHead;
    import flash.geom.Point;
    import __AS3__.vec.Vector;
    import ddt.view.sceneCharacter.SceneCharacterItem;
    import ddt.view.sceneCharacter.SceneCharacterActionItem;
    import ddt.view.sceneCharacter.SceneCharacterStateItem;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class WalkMapPlayerBase extends SceneCharacterPlayerBase 
    {

        private var _playerInfo:PlayerInfo;
        private var _sceneCharacterStateSet:SceneCharacterStateSet;
        private var _sceneCharacterSetNatural:SceneCharacterSet;
        private var _sceneCharacterActionSetNatural:SceneCharacterActionSet;
        private var _headBitmapData:BitmapData;
        private var _bodyBitmapData:BitmapData;
        private var _rectangle:Rectangle = new Rectangle();
        public var playerWitdh:Number = 120;
        public var playerHeight:Number = 175;
        private var _sceneCharacterLoaderBody:SceneCharacterLoaderBody;
        private var _sceneCharacterLoaderHead:SceneCharacterLoaderHead;

        public function WalkMapPlayerBase(_arg_1:PlayerInfo, _arg_2:Function=null)
        {
            super(_arg_2);
            this._playerInfo = _arg_1;
            this.initialize();
        }

        private function initialize():void
        {
            this._sceneCharacterStateSet = new SceneCharacterStateSet();
            this._sceneCharacterActionSetNatural = new SceneCharacterActionSet();
            this.sceneCharacterLoadHead();
        }

        private function sceneCharacterLoadHead():void
        {
            this._sceneCharacterLoaderHead = new SceneCharacterLoaderHead(this._playerInfo);
            this._sceneCharacterLoaderHead.load(this.sceneCharacterLoaderHeadCallBack);
        }

        private function sceneCharacterLoaderHeadCallBack(_arg_1:SceneCharacterLoaderHead, _arg_2:Boolean=true):void
        {
            this._headBitmapData = (_arg_1.getContent()[0] as BitmapData);
            if (_arg_1)
            {
                _arg_1.dispose();
            };
            if (((!(_arg_2)) || (!(this._headBitmapData))))
            {
                if (_callBack != null)
                {
                    _callBack(this, false);
                };
                return;
            };
            this.sceneCharacterStateNatural();
        }

        private function sceneCharacterStateNatural():void
        {
            var _local_1:BitmapData;
            this._sceneCharacterSetNatural = new SceneCharacterSet();
            var _local_2:Vector.<Point> = new Vector.<Point>();
            _local_2.push(new Point(0, 0));
            _local_2.push(new Point(0, 0));
            _local_2.push(new Point(0, -1));
            _local_2.push(new Point(0, 2));
            _local_2.push(new Point(0, 0));
            _local_2.push(new Point(0, -1));
            _local_2.push(new Point(0, 2));
            if ((!(this._rectangle)))
            {
                this._rectangle = new Rectangle();
            };
            this._rectangle.x = 0;
            this._rectangle.y = 0;
            this._rectangle.width = this.playerWitdh;
            this._rectangle.height = this.playerHeight;
            _local_1 = new BitmapData(this.playerWitdh, this.playerHeight, true, 0);
            _local_1.copyPixels(this._headBitmapData, this._rectangle, new Point(0, 0));
            this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontHead", "NaturalFrontAction", _local_1, 1, 1, this.playerWitdh, this.playerHeight, 1, _local_2, true, 7));
            this._rectangle.x = this.playerWitdh;
            this._rectangle.y = 0;
            this._rectangle.width = this.playerWitdh;
            this._rectangle.height = this.playerHeight;
            _local_1 = new BitmapData(this.playerWitdh, this.playerHeight, true, 0);
            _local_1.copyPixels(this._headBitmapData, this._rectangle, new Point(0, 0));
            this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontEyesCloseHead", "NaturalFrontEyesCloseAction", _local_1, 1, 1, this.playerWitdh, this.playerHeight, 2));
            this._rectangle.x = (this.playerWitdh * 2);
            this._rectangle.y = 0;
            this._rectangle.width = this.playerWitdh;
            this._rectangle.height = this.playerHeight;
            _local_1 = new BitmapData(this.playerWitdh, (this.playerHeight * 2), true, 0);
            _local_1.copyPixels(this._headBitmapData, this._rectangle, new Point(0, 0));
            this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalBackHead", "NaturalBackAction", _local_1, 1, 1, this.playerWitdh, this.playerHeight, 6, _local_2, true, 7));
            this.sceneCharacterLoadBodyNatural();
        }

        private function sceneCharacterLoadBodyNatural():void
        {
            this._sceneCharacterLoaderBody = new SceneCharacterLoaderBody(this._playerInfo);
            this._sceneCharacterLoaderBody.load(this.sceneCharacterLoaderBodyNaturalCallBack);
        }

        private function sceneCharacterLoaderBodyNaturalCallBack(_arg_1:SceneCharacterLoaderBody, _arg_2:Boolean):void
        {
            var _local_3:BitmapData;
            if ((!(this._sceneCharacterSetNatural)))
            {
                return;
            };
            this._bodyBitmapData = (_arg_1.getContent()[0] as BitmapData);
            if (_arg_1)
            {
                _arg_1.dispose();
            };
            if (((!(_arg_2)) || (!(this._bodyBitmapData))))
            {
                if (_callBack != null)
                {
                    _callBack(this, false);
                };
                return;
            };
            if ((!(this._rectangle)))
            {
                this._rectangle = new Rectangle();
            };
            this._rectangle.x = 0;
            this._rectangle.y = 0;
            this._rectangle.width = this._bodyBitmapData.width;
            this._rectangle.height = this.playerHeight;
            _local_3 = new BitmapData(this._bodyBitmapData.width, this.playerHeight, true, 0);
            _local_3.copyPixels(this._bodyBitmapData, this._rectangle, new Point(0, 0));
            this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontBody", "NaturalFrontAction", _local_3, 1, 7, this.playerWitdh, this.playerHeight, 3));
            this._rectangle.x = 0;
            this._rectangle.y = 0;
            this._rectangle.width = this.playerWitdh;
            this._rectangle.height = this.playerHeight;
            _local_3 = new BitmapData(this.playerWitdh, this.playerHeight, true, 0);
            _local_3.copyPixels(this._bodyBitmapData, this._rectangle, new Point(0, 0));
            this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontEyesCloseBody", "NaturalFrontEyesCloseAction", _local_3, 1, 1, this.playerWitdh, this.playerHeight, 4));
            this._rectangle.x = 0;
            this._rectangle.y = this.playerHeight;
            this._rectangle.width = this._bodyBitmapData.width;
            this._rectangle.height = this.playerHeight;
            _local_3 = new BitmapData(this._bodyBitmapData.width, this.playerHeight, true, 0);
            _local_3.copyPixels(this._bodyBitmapData, this._rectangle, new Point(0, 0));
            this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalBackBody", "NaturalBackAction", _local_3, 1, 7, this.playerWitdh, this.playerHeight, 5));
            var _local_4:SceneCharacterActionItem = new SceneCharacterActionItem("naturalStandFront", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 7, 7], true);
            this._sceneCharacterActionSetNatural.push(_local_4);
            var _local_5:SceneCharacterActionItem = new SceneCharacterActionItem("naturalStandBack", [8], false);
            this._sceneCharacterActionSetNatural.push(_local_5);
            var _local_6:SceneCharacterActionItem = new SceneCharacterActionItem("naturalWalkFront", [1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6], true);
            this._sceneCharacterActionSetNatural.push(_local_6);
            var _local_7:SceneCharacterActionItem = new SceneCharacterActionItem("naturalWalkBack", [9, 9, 9, 10, 10, 10, 11, 11, 11, 12, 12, 12, 13, 13, 13, 14, 14, 14], true);
            this._sceneCharacterActionSetNatural.push(_local_7);
            var _local_8:SceneCharacterStateItem = new SceneCharacterStateItem("natural", this._sceneCharacterSetNatural, this._sceneCharacterActionSetNatural);
            this._sceneCharacterStateSet.push(_local_8);
            super.sceneCharacterStateSet = this._sceneCharacterStateSet;
        }

        override public function dispose():void
        {
            this._playerInfo = null;
            _callBack = null;
            if (this._sceneCharacterSetNatural)
            {
                this._sceneCharacterSetNatural.dispose();
            };
            this._sceneCharacterSetNatural = null;
            if (this._sceneCharacterActionSetNatural)
            {
                this._sceneCharacterActionSetNatural.dispose();
            };
            this._sceneCharacterActionSetNatural = null;
            if (this._sceneCharacterStateSet)
            {
                this._sceneCharacterStateSet.dispose();
            };
            this._sceneCharacterStateSet = null;
            ObjectUtils.disposeObject(this._sceneCharacterLoaderBody);
            this._sceneCharacterLoaderBody = null;
            ObjectUtils.disposeObject(this._sceneCharacterLoaderHead);
            this._sceneCharacterLoaderHead = null;
            if (this._headBitmapData)
            {
                this._headBitmapData.dispose();
            };
            this._headBitmapData = null;
            if (this._bodyBitmapData)
            {
                this._bodyBitmapData.dispose();
            };
            this._bodyBitmapData = null;
            this._rectangle = null;
            if (parent)
            {
                parent.removeChild(this);
            };
            super.dispose();
        }


    }
}//package SingleDungeon.player

