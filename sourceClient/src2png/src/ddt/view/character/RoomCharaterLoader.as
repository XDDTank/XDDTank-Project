// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.character.RoomCharaterLoader

package ddt.view.character
{
    import flash.display.BitmapData;
    import ddt.data.player.PlayerInfo;
    import ddt.manager.ItemManager;
    import ddt.data.goods.ItemTemplateInfo;
    import flash.display.Shape;
    import flash.display.BlendMode;
    import flash.display.MovieClip;
    import __AS3__.vec.*;

    public class RoomCharaterLoader extends BaseCharacterLoader 
    {

        private var _suit:BitmapData;
        private var _faceUpBmd:BitmapData;
        private var _faceBmd:BitmapData;
        public var showWeapon:Boolean;

        public function RoomCharaterLoader(_arg_1:PlayerInfo)
        {
            super(_arg_1);
        }

        override protected function initLayers():void
        {
            var _local_1:ILayer;
            if (_layers != null)
            {
                for each (_local_1 in _layers)
                {
                    _local_1.dispose();
                };
                _layers = null;
            };
            _layers = new Vector.<ILayer>();
            _recordStyle = _info.Style.split(",");
            _recordColor = _info.Colors.split(",");
            this.loadPart(7);
            this.loadPart(1);
            this.loadPart(4);
            this.loadPart(3);
            this.loadPart(0);
            this.loadPart(2);
            this.loadPart(5);
            this.laodArm();
            this.loadPart(8);
        }

        override protected function getIndexByTemplateId(_arg_1:String):int
        {
            var _local_2:ItemTemplateInfo = ItemManager.Instance.getTemplateById(int(_arg_1));
            if (_local_2 == null)
            {
                return (-1);
            };
            switch (_local_2.CategoryID.toString())
            {
                case "1":
                case "10":
                case "11":
                case "12":
                    return (2);
                case "13":
                    return (0);
                case "15":
                    return (8);
                case "16":
                    return (9);
                case "17":
                    return (-1);
                case "2":
                    return (1);
                case "3":
                    return (5);
                case "4":
                    return (3);
                case "5":
                    return (4);
                case "6":
                    return (6);
                case "27":
                case "40":
                    return (7);
                default:
                    return (-1);
            };
        }

        private function loadPart(_arg_1:int):void
        {
            if (_recordStyle[_arg_1].split("|")[0] > 0)
            {
                _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[_arg_1].split("|")[0])), _info.Sex, _recordColor[_arg_1], BaseLayer.SHOW, (_arg_1 == 2), _info.getHairType()));
            };
        }

        private function laodArm():void
        {
            if (_recordStyle[6].split("|")[0] > 0)
            {
                _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[6].split("|")[0])), _info.Sex, _recordColor[6], BaseLayer.SHOW, false, _info.getHairType(), _recordStyle[6].split("|")[1]));
            };
        }

        override protected function drawCharacter():void
        {
            var _local_3:Shape;
            var _local_4:BitmapData;
            var _local_1:Number = ShowCharacter.BIG_WIDTH;
            var _local_2:Number = ShowCharacter.BIG_HEIGHT;
            if (((_local_1 == 0) || (_local_2 == 0)))
            {
                return;
            };
            if (this._suit)
            {
                this._suit.dispose();
            };
            this._suit = new BitmapData((_local_1 * 4), _local_2, true, 0);
            if (this._faceUpBmd)
            {
                this._faceUpBmd.dispose();
            };
            this._faceUpBmd = new BitmapData(_local_1, _local_2, true, 0);
            if (this._faceBmd)
            {
                this._faceBmd.dispose();
            };
            this._faceBmd = new BitmapData((_local_1 * 4), _local_2, true, 0);
            if (_info.getShowSuits())
            {
                this._suit.draw(_layers[0].getContent(), null, null, BlendMode.NORMAL);
                if ((((!(_info.WeaponID == 0)) && (!(_info.WeaponID == -1))) && (this.showWeapon)))
                {
                    _local_3 = new Shape();
                    _local_4 = new BitmapData(_local_1, _local_2, true, 0);
                    _local_4.draw(_layers[7].getContent());
                    _local_3.graphics.beginBitmapFill(_local_4, null, true, true);
                    _local_3.graphics.drawRect(0, 0, (_local_1 * 4), _local_2);
                    _local_3.graphics.endFill();
                    this._suit.draw(_local_3, null, null, BlendMode.NORMAL);
                    _local_4.dispose();
                };
            }
            else
            {
                this._faceUpBmd.draw(_layers[5].getContent(), null, null, BlendMode.NORMAL);
                this._faceUpBmd.draw(_layers[4].getContent(), null, null, BlendMode.NORMAL);
                this._faceUpBmd.draw(_layers[3].getContent(), null, null, BlendMode.NORMAL);
                this._faceUpBmd.draw(_layers[2].getContent(), null, null, BlendMode.NORMAL);
                this._faceUpBmd.draw(_layers[1].getContent(), null, null, BlendMode.NORMAL);
                this._faceBmd.draw(_layers[6].getContent(), null, null, BlendMode.NORMAL);
                if ((((!(_info.WeaponID == 0)) && (!(_info.WeaponID == -1))) && (this.showWeapon)))
                {
                    this._faceUpBmd.draw(_layers[7].getContent(), null, null, BlendMode.NORMAL);
                };
            };
            _wing = (_layers[8].getContent() as MovieClip);
        }

        override public function getContent():Array
        {
            return ([this._suit, this._faceUpBmd, this._faceBmd, _wing]);
        }


    }
}//package ddt.view.character

