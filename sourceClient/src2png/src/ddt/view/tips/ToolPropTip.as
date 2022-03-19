// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.ToolPropTip

package ddt.view.tips
{
    import com.pickgliss.ui.tip.BaseTip;
    import ddt.data.goods.ItemTemplateInfo;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import flash.text.TextField;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.text.TextFormat;
    import flash.display.Sprite;
    import com.pickgliss.ui.ComponentFactory;
    import flash.text.TextFieldAutoSize;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.utils.ObjectUtils;

    public class ToolPropTip extends BaseTip 
    {

        private var _info:ItemTemplateInfo;
        private var _count:int = 0;
        private var _showTurn:Boolean;
        private var _showCount:Boolean;
        private var _showThew:Boolean;
        private var _bg:ScaleBitmapImage;
        private var context:TextField;
        private var thew_txt:FilterFrameText;
        private var turn_txt:FilterFrameText;
        private var description_txt:FilterFrameText;
        private var name_txt:FilterFrameText;
        private var _tempData:Object;
        private var f:TextFormat = new TextFormat(null, 13, 0xFFFFFF);
        private var _container:Sprite;


        override protected function init():void
        {
            this.name_txt = ComponentFactory.Instance.creat("core.ToolNameTxt");
            this.thew_txt = ComponentFactory.Instance.creat("core.ToolThewTxt");
            this.description_txt = ComponentFactory.Instance.creat("core.ToolDescribeTxt");
            this.turn_txt = ComponentFactory.Instance.creat("core.ToolGoldTxt");
            this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
            this._container = new Sprite();
            this._container.addChild(this.thew_txt);
            this._container.addChild(this.turn_txt);
            this._container.addChild(this.description_txt);
            this._container.addChild(this.name_txt);
            super.init();
            this.tipbackgound = this._bg;
        }

        override protected function addChildren():void
        {
            super.addChildren();
            addChild(this._container);
            this._container.mouseEnabled = false;
            this._container.mouseChildren = false;
            this.mouseChildren = false;
            this.mouseEnabled = false;
        }

        override public function get tipData():Object
        {
            return (this._tempData);
        }

        override public function set tipData(_arg_1:Object):void
        {
            this._tempData = _arg_1;
            if ((_arg_1 is ToolPropInfo))
            {
                this.visible = true;
                this.update(_arg_1.showTurn, _arg_1.showCount, _arg_1.showThew, _arg_1.valueType, _arg_1.info, _arg_1.count, _arg_1.shortcutKey);
            }
            else
            {
                this.visible = false;
            };
        }

        public function changeStyle(_arg_1:ItemTemplateInfo, _arg_2:int, _arg_3:Boolean=true):void
        {
            this.thew_txt.width = (this.turn_txt.width = (this.description_txt.width = (this.name_txt.width = 0)));
            this.thew_txt.y = (this.turn_txt.y = (this.description_txt.y = (this.name_txt.y = 0)));
            this.thew_txt.text = (this.turn_txt.text = (this.description_txt.text = (this.name_txt.text = "")));
            if ((!(this.context)))
            {
                this.context = new TextField();
                this.context.width = (_arg_2 - 2);
                this.context.autoSize = TextFieldAutoSize.CENTER;
                this._container.addChild(this.context);
                this.context = new TextField();
                this.context.width = (_arg_2 - 2);
                if (_arg_3)
                {
                    this.context.wordWrap = true;
                    this.context.autoSize = TextFieldAutoSize.LEFT;
                    this.context.x = 2;
                    this.context.y = 2;
                }
                else
                {
                    this.context.wordWrap = false;
                    this.context.autoSize = TextFieldAutoSize.CENTER;
                    this.context.y = 4;
                };
                this._container.addChild(this.context);
            };
            this._info = _arg_1;
            if (this._info)
            {
                this.context.text = this._info.Description;
            };
            this.context.setTextFormat(this.f);
            this._bg.height = 0;
            this.drawBG(_arg_2);
        }

        private function judge4cell(_arg_1:String):Boolean
        {
            var _local_2:ToolPropInfo = (this._tempData as ToolPropInfo);
            if (((((_local_2) && (_arg_1 == "4")) && (this._info)) && (_local_2.isMax)))
            {
                return (true);
            };
            return (false);
        }

        private function update(_arg_1:Boolean, _arg_2:Boolean, _arg_3:Boolean, _arg_4:String, _arg_5:ItemTemplateInfo, _arg_6:int, _arg_7:String):void
        {
            this._showCount = _arg_2;
            this._showTurn = _arg_1;
            this._showThew = _arg_3;
            this._info = _arg_5;
            this._count = _arg_6;
            this.name_txt.autoSize = TextFieldAutoSize.LEFT;
            if (this._showCount)
            {
                if (this._count > 1)
                {
                    this.name_txt.text = (((String(this._info.Name) + "(") + String(this._count)) + ")");
                }
                else
                {
                    if (this._count == -1)
                    {
                        this.name_txt.text = (((String(this._info.Name) + "(") + LanguageMgr.GetTranslation("tank.view.common.RoomIIPropTip.infinity")) + ")");
                    }
                    else
                    {
                        this.name_txt.text = String(this._info.Name);
                    };
                };
            }
            else
            {
                if (this.judge4cell(_arg_7))
                {
                    this.name_txt.text = LanguageMgr.GetTranslation("tank.game.RightProp.4cell.name");
                }
                else
                {
                    this.name_txt.text = String(this._info.Name);
                };
            };
            if (_arg_7)
            {
                this.name_txt.text = (this.name_txt.text + ((" [" + _arg_7.toLocaleUpperCase()) + "]"));
            };
            if (this._showThew)
            {
                if (_arg_4 == ToolPropInfo.Psychic)
                {
                    this.thew_txt.htmlText = LanguageMgr.GetTranslation(("tank.view.common.RoomIIPropTip." + _arg_4), String(this._info.Property7));
                }
                else
                {
                    if (_arg_4 == ToolPropInfo.Energy)
                    {
                        if (this.judge4cell(_arg_7))
                        {
                            this.thew_txt.htmlText = LanguageMgr.GetTranslation(("tank.view.common.RoomIIPropTip." + _arg_4), LanguageMgr.GetTranslation("tank.game.RightProp.4cell.lastEnergy"));
                        }
                        else
                        {
                            this.thew_txt.htmlText = LanguageMgr.GetTranslation(("tank.view.common.RoomIIPropTip." + _arg_4), String(this._info.Property4));
                        };
                    }
                    else
                    {
                        if (_arg_4 == ToolPropInfo.MP)
                        {
                            this.thew_txt.htmlText = LanguageMgr.GetTranslation(("tank.view.common.RoomIIPropTip." + _arg_4), String(this._info.Property4));
                        }
                        else
                        {
                            this.thew_txt.text = "";
                        };
                    };
                };
                this.description_txt.y = (this.thew_txt.y + this.thew_txt.height);
                this.thew_txt.visible = true;
            }
            else
            {
                this.thew_txt.visible = false;
                this.description_txt.y = this.thew_txt.y;
            };
            this.description_txt.autoSize = TextFieldAutoSize.NONE;
            this.description_txt.width = 150;
            this.description_txt.wordWrap = true;
            this.description_txt.autoSize = TextFieldAutoSize.LEFT;
            if (this.judge4cell(_arg_7))
            {
                this.description_txt.htmlText = LanguageMgr.GetTranslation("tank.view.common.RoomIIPropTip.Description", LanguageMgr.GetTranslation("tank.game.RightProp.4cell.description"));
            }
            else
            {
                this.description_txt.htmlText = LanguageMgr.GetTranslation("tank.view.common.RoomIIPropTip.Description", this._info.Description);
            };
            if (this._showTurn)
            {
                this.turn_txt.visible = true;
                this.turn_txt.y = ((this.description_txt.y + this.description_txt.height) + 5);
                this.turn_txt.text = (((LanguageMgr.GetTranslation("tank.game.actions.cooldown") + ": ") + this._info.Property1) + LanguageMgr.GetTranslation("tank.game.actions.turn"));
            }
            else
            {
                this.turn_txt.visible = false;
                this.turn_txt.y = 0;
            };
            this.drawBG();
        }

        private function reset():void
        {
            this._bg.height = 0;
            this._bg.width = 0;
        }

        private function drawBG(_arg_1:int=0):void
        {
            this.reset();
            if (_arg_1 == 0)
            {
                this._bg.width = (this._container.width + 10);
                this._bg.height = (this._container.height + 6);
            }
            else
            {
                this._bg.width = (_arg_1 + 2);
                this._bg.height = (this._container.height + 5);
            };
            _width = this._bg.width;
            _height = this._bg.height;
        }

        override public function dispose():void
        {
            if (((this.context) && (this.context.parent)))
            {
                this.context.parent.removeChild(this.context);
            };
            this.context = null;
            this._info = null;
            ObjectUtils.disposeObject(this.thew_txt);
            this.thew_txt = null;
            ObjectUtils.disposeObject(this.turn_txt);
            this.turn_txt = null;
            ObjectUtils.disposeObject(this.description_txt);
            this.description_txt = null;
            ObjectUtils.disposeObject(this.name_txt);
            this.name_txt = null;
            super.dispose();
        }


    }
}//package ddt.view.tips

