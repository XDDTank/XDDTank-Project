package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
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
      
      private var f:TextFormat;
      
      private var _container:Sprite;
      
      public function ToolPropTip()
      {
         this.f = new TextFormat(null,13,16777215);
         super();
      }
      
      override protected function init() : void
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
      
      override protected function addChildren() : void
      {
         super.addChildren();
         addChild(this._container);
         this._container.mouseEnabled = false;
         this._container.mouseChildren = false;
         this.mouseChildren = false;
         this.mouseEnabled = false;
      }
      
      override public function get tipData() : Object
      {
         return this._tempData;
      }
      
      override public function set tipData(param1:Object) : void
      {
         this._tempData = param1;
         if(param1 is ToolPropInfo)
         {
            this.visible = true;
            this.update(param1.showTurn,param1.showCount,param1.showThew,param1.valueType,param1.info,param1.count,param1.shortcutKey);
         }
         else
         {
            this.visible = false;
         }
      }
      
      public function changeStyle(param1:ItemTemplateInfo, param2:int, param3:Boolean = true) : void
      {
         this.thew_txt.width = this.turn_txt.width = this.description_txt.width = this.name_txt.width = 0;
         this.thew_txt.y = this.turn_txt.y = this.description_txt.y = this.name_txt.y = 0;
         this.thew_txt.text = this.turn_txt.text = this.description_txt.text = this.name_txt.text = "";
         if(!this.context)
         {
            this.context = new TextField();
            this.context.width = param2 - 2;
            this.context.autoSize = TextFieldAutoSize.CENTER;
            this._container.addChild(this.context);
            this.context = new TextField();
            this.context.width = param2 - 2;
            if(param3)
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
            }
            this._container.addChild(this.context);
         }
         this._info = param1;
         if(this._info)
         {
            this.context.text = this._info.Description;
         }
         this.context.setTextFormat(this.f);
         this._bg.height = 0;
         this.drawBG(param2);
      }
      
      private function judge4cell(param1:String) : Boolean
      {
         var _loc2_:ToolPropInfo = this._tempData as ToolPropInfo;
         if(_loc2_ && param1 == "4" && this._info && _loc2_.isMax)
         {
            return true;
         }
         return false;
      }
      
      private function update(param1:Boolean, param2:Boolean, param3:Boolean, param4:String, param5:ItemTemplateInfo, param6:int, param7:String) : void
      {
         this._showCount = param2;
         this._showTurn = param1;
         this._showThew = param3;
         this._info = param5;
         this._count = param6;
         this.name_txt.autoSize = TextFieldAutoSize.LEFT;
         if(this._showCount)
         {
            if(this._count > 1)
            {
               this.name_txt.text = String(this._info.Name) + "(" + String(this._count) + ")";
            }
            else if(this._count == -1)
            {
               this.name_txt.text = String(this._info.Name) + "(" + LanguageMgr.GetTranslation("tank.view.common.RoomIIPropTip.infinity") + ")";
            }
            else
            {
               this.name_txt.text = String(this._info.Name);
            }
         }
         else if(this.judge4cell(param7))
         {
            this.name_txt.text = LanguageMgr.GetTranslation("tank.game.RightProp.4cell.name");
         }
         else
         {
            this.name_txt.text = String(this._info.Name);
         }
         if(param7)
         {
            this.name_txt.text += " [" + param7.toLocaleUpperCase() + "]";
         }
         if(this._showThew)
         {
            if(param4 == ToolPropInfo.Psychic)
            {
               this.thew_txt.htmlText = LanguageMgr.GetTranslation("tank.view.common.RoomIIPropTip." + param4,String(this._info.Property7));
            }
            else if(param4 == ToolPropInfo.Energy)
            {
               if(this.judge4cell(param7))
               {
                  this.thew_txt.htmlText = LanguageMgr.GetTranslation("tank.view.common.RoomIIPropTip." + param4,LanguageMgr.GetTranslation("tank.game.RightProp.4cell.lastEnergy"));
               }
               else
               {
                  this.thew_txt.htmlText = LanguageMgr.GetTranslation("tank.view.common.RoomIIPropTip." + param4,String(this._info.Property4));
               }
            }
            else if(param4 == ToolPropInfo.MP)
            {
               this.thew_txt.htmlText = LanguageMgr.GetTranslation("tank.view.common.RoomIIPropTip." + param4,String(this._info.Property4));
            }
            else
            {
               this.thew_txt.text = "";
            }
            this.description_txt.y = this.thew_txt.y + this.thew_txt.height;
            this.thew_txt.visible = true;
         }
         else
         {
            this.thew_txt.visible = false;
            this.description_txt.y = this.thew_txt.y;
         }
         this.description_txt.autoSize = TextFieldAutoSize.NONE;
         this.description_txt.width = 150;
         this.description_txt.wordWrap = true;
         this.description_txt.autoSize = TextFieldAutoSize.LEFT;
         if(this.judge4cell(param7))
         {
            this.description_txt.htmlText = LanguageMgr.GetTranslation("tank.view.common.RoomIIPropTip.Description",LanguageMgr.GetTranslation("tank.game.RightProp.4cell.description"));
         }
         else
         {
            this.description_txt.htmlText = LanguageMgr.GetTranslation("tank.view.common.RoomIIPropTip.Description",this._info.Description);
         }
         if(this._showTurn)
         {
            this.turn_txt.visible = true;
            this.turn_txt.y = this.description_txt.y + this.description_txt.height + 5;
            this.turn_txt.text = LanguageMgr.GetTranslation("tank.game.actions.cooldown") + ": " + this._info.Property1 + LanguageMgr.GetTranslation("tank.game.actions.turn");
         }
         else
         {
            this.turn_txt.visible = false;
            this.turn_txt.y = 0;
         }
         this.drawBG();
      }
      
      private function reset() : void
      {
         this._bg.height = 0;
         this._bg.width = 0;
      }
      
      private function drawBG(param1:int = 0) : void
      {
         this.reset();
         if(param1 == 0)
         {
            this._bg.width = this._container.width + 10;
            this._bg.height = this._container.height + 6;
         }
         else
         {
            this._bg.width = param1 + 2;
            this._bg.height = this._container.height + 5;
         }
         _width = this._bg.width;
         _height = this._bg.height;
      }
      
      override public function dispose() : void
      {
         if(this.context && this.context.parent)
         {
            this.context.parent.removeChild(this.context);
         }
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
}
