// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.character.BaseCharacterLoader

package ddt.view.character
{
    import __AS3__.vec.Vector;
    import ddt.data.player.PlayerInfo;
    import flash.display.BitmapData;
    import flash.display.MovieClip;
    import ddt.manager.ItemManager;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.data.EquipType;
    import flash.display.BlendMode;
    import ddt.utils.MenoryUtil;
    import __AS3__.vec.*;

    public class BaseCharacterLoader implements ICharacterLoader 
    {

        protected var _layers:Vector.<ILayer>;
        protected var _layerFactory:ILayerFactory;
        protected var _info:PlayerInfo;
        protected var _recordStyle:Array;
        protected var _recordColor:Array;
        protected var _content:BitmapData;
        private var _callBack:Function;
        private var _completeCount:int;
        protected var _wing:MovieClip = new MovieClip();
        private var _disposed:Boolean;

        public function BaseCharacterLoader(_arg_1:PlayerInfo)
        {
            this._info = _arg_1;
        }

        protected function initLayers():void
        {
            var _local_1:ILayer;
            if (this._layers != null)
            {
                for each (_local_1 in this._layers)
                {
                    _local_1.dispose();
                };
                this._layers = null;
            };
            this._layers = new Vector.<ILayer>();
            this._recordStyle = this._info.Style.split(",");
            this._recordColor = this._info.Colors.split(",");
            this._layers.push(this._layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[7].split("|")[0])), this._info.Sex, this._recordColor[7], BaseLayer.SHOW));
            this._layers.push(this._layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[1].split("|")[0])), this._info.Sex, this._recordColor[1], BaseLayer.SHOW));
            this._layers.push(this._layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[0].split("|")[0])), this._info.Sex, this._recordColor[0], BaseLayer.SHOW));
            this._layers.push(this._layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[3].split("|")[0])), this._info.Sex, this._recordColor[3], BaseLayer.SHOW));
            this._layers.push(this._layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[4].split("|")[0])), this._info.Sex, this._recordColor[4], BaseLayer.SHOW));
            this._layers.push(this._layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[2].split("|")[0])), this._info.Sex, this._recordColor[2], BaseLayer.SHOW, false, this._info.getHairType()));
            this._layers.push(this._layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[5].split("|")[0])), this._info.Sex, this._recordColor[5], BaseLayer.SHOW));
            this._layers.push(this._layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[6].split("|")[0])), this._info.Sex, this._recordColor[6], BaseLayer.SHOW));
            this._layers.push(this._layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[8].split("|")[0])), this._info.Sex, this._recordColor[8], BaseLayer.SHOW));
        }

        protected function getIndexByTemplateId(_arg_1:String):int
        {
            if (int(_arg_1) == 3261)
            {
            };
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
                    return (4);
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
                    return (2);
                case "6":
                    return (6);
                case "7":
                case "27":
                    return (7);
                case "40":
                    return (7);
                default:
                    return (-1);
            };
        }

        final public function load(_arg_1:Function=null):void
        {
            var _local_4:ILayer;
            this._callBack = _arg_1;
            if ((((this._layerFactory == null) || (this._info == null)) || (this._info.Style == null)))
            {
                this.loadComplete();
                return;
            };
            this.initLayers();
            var _local_2:int = this._layers.length;
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                _local_4 = this._layers[_local_3];
                _local_4.load(this.__layerComplete);
                _local_3++;
            };
        }

        public function getUnCompleteLog():String
        {
            var _local_4:ILayer;
            var _local_1:String = "";
            if (this._layers == null)
            {
                return ("_layers == null\n");
            };
            var _local_2:int = this._layers.length;
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                _local_4 = this._layers[_local_3];
                if ((!(this._layers[_local_3].isComplete)))
                {
                    _local_1 = (_local_1 + (("unLoaded templete: " + this._layers[_local_3].info.TemplateID.toString()) + "\n"));
                };
                _local_3++;
            };
            return (_local_1);
        }

        private function __layerComplete(_arg_1:ILayer):void
        {
            if (this._layers == null)
            {
                return;
            };
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
                this.drawCharacter();
                this.loadComplete();
            };
        }

        protected function loadComplete():void
        {
            if (this._callBack != null)
            {
                this._callBack(this);
            };
        }

        protected function drawCharacter():void
        {
            var _local_1:Number = this._layers[1].width;
            var _local_2:Number = this._layers[1].height;
            if (((_local_1 == 0) || (_local_2 == 0)))
            {
                return;
            };
            if (this._content)
            {
                this._content.dispose();
            };
            this._content = new BitmapData(_local_1, _local_2, true, 0);
            var _local_3:int = (this._layers.length - 1);
            for (;_local_3 >= 0;_local_3--)
            {
                if (this._info.getShowSuits())
                {
                    if ((((!(this._layers[_local_3].info.CategoryID == EquipType.SUITS)) && (!(this._layers[_local_3].info.CategoryID == EquipType.WING))) && (!(EquipType.isWeapon(this._layers[_local_3].info.TemplateID))))) continue;
                }
                else
                {
                    if (this._layers[_local_3].info.CategoryID == EquipType.SUITS) continue;
                };
                if (this._layers[_local_3].info.CategoryID == EquipType.WING)
                {
                    this._wing = (this._layers[_local_3].getContent() as MovieClip);
                }
                else
                {
                    this._content.draw((this._layers[_local_3] as ILayer).getContent(), null, null, BlendMode.NORMAL);
                };
            };
            MenoryUtil.clearMenory();
        }

        public function getContent():Array
        {
            return ([this._content, this._wing]);
        }

        public function setFactory(_arg_1:ILayerFactory):void
        {
            this._layerFactory = _arg_1;
        }

        public function update():void
        {
            var _local_1:Array;
            var _local_2:Array;
            var _local_3:Boolean;
            var _local_4:Boolean;
            var _local_5:int;
            var _local_6:int;
            var _local_7:ItemTemplateInfo;
            var _local_8:ILayer;
            var _local_9:ItemTemplateInfo;
            var _local_10:ILayer;
            var _local_11:int;
            if ((((this._info) && (this._info.Style)) && (this._layers)))
            {
                _local_1 = this._info.Style.split(",");
                _local_2 = this._info.Colors.split(",");
                _local_3 = false;
                _local_4 = false;
                _local_5 = 0;
                while (_local_5 < _local_1.length)
                {
                    if (this._recordStyle == null) break;
                    if (_local_5 >= this._recordStyle.length) break;
                    if (!EquipType.isOffHand(_local_1[_local_5].split("|")[0]))
                    {
                        _local_6 = this.getIndexByTemplateId(_local_1[_local_5].split("|")[0]);
                        if (!((_local_6 == -1) || (_local_6 == 9)))
                        {
                            if (this._recordStyle.indexOf(_local_1[_local_5]) == -1)
                            {
                                if ((!(_local_3)))
                                {
                                    _local_3 = (_local_1[_local_5].charAt(0) == EquipType.HEAD);
                                };
                                if ((!(_local_4)))
                                {
                                    _local_4 = (_local_1[_local_5].charAt(0) == EquipType.HAIR);
                                };
                                _local_7 = ItemManager.Instance.getTemplateById(int(_local_1[_local_5].split("|")[0]));
                                _local_8 = this.getCharacterLoader(_local_7, _local_2[_local_5], _local_1[_local_5].split("|")[1]);
                                if (this._layers[_local_6])
                                {
                                    this._layers[_local_6].dispose();
                                };
                                this._layers[_local_6] = _local_8;
                                _local_8.load(this.__layerComplete);
                            }
                            else
                            {
                                if (_local_2[_local_5] != null)
                                {
                                    if (this._recordColor[_local_5] != _local_2[_local_5])
                                    {
                                        this._layers[_local_6].setColor(_local_2[_local_5]);
                                    };
                                };
                            };
                        };
                    };
                    _local_5++;
                };
                if ((((((this._info) && (_local_3)) && (!(_local_4))) && (!(this._info.getShowSuits()))) && (!(this._info.wingHide))))
                {
                    _local_9 = ItemManager.Instance.getTemplateById(this._info.getPartStyle(EquipType.HAIR));
                    _local_10 = this.getCharacterLoader(_local_9, this._info.getPartColor(EquipType.HAIR));
                    _local_11 = this.getIndexByTemplateId(String(_local_9.TemplateID));
                    if (this._layers[_local_11])
                    {
                        this._layers[_local_11].dispose();
                    };
                    this._layers[_local_11] = _local_10;
                    _local_10.load(this.__layerComplete);
                };
                this.__layerComplete(null);
                this._recordStyle = _local_1;
                this._recordColor = _local_2;
            };
        }

        protected function getCharacterLoader(_arg_1:ItemTemplateInfo, _arg_2:String="", _arg_3:String=null):ILayer
        {
            if (_arg_1.CategoryID == EquipType.HAIR)
            {
                return (this._layerFactory.createLayer(_arg_1, this._info.Sex, _arg_2, BaseLayer.SHOW, false, this._info.getHairType(), _arg_3));
            };
            return (this._layerFactory.createLayer(_arg_1, this._info.Sex, _arg_2, BaseLayer.SHOW, false, 1, _arg_3));
        }

        public function dispose():void
        {
            this._disposed = true;
            this._content = null;
            var _local_1:int;
            while (_local_1 < this._layers.length)
            {
                this._layers[_local_1].dispose();
                _local_1++;
            };
            this._wing = null;
            this._layers = null;
            this._layerFactory = null;
            this._info = null;
            this._callBack = null;
        }


    }
}//package ddt.view.character

