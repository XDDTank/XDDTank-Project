package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.EquipmentTemplateInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   
   public class EquipTipEmbedItem extends Component
   {
       
      
      private var _index:int;
      
      private var _embedHole:ScaleFrameImage;
      
      private var _embedTypeImage:ScaleFrameImage;
      
      private var _embedText:FilterFrameText;
      
      private var _unembedText:FilterFrameText;
      
      private var _holeID:int;
      
      public function EquipTipEmbedItem(param1:int)
      {
         this._index = param1;
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._embedHole = ComponentFactory.Instance.creat("EquipsTipPanel.embedBg");
         addChild(this._embedHole);
         this._embedTypeImage = ComponentFactory.Instance.creat("EquipsTipPanel.embedIcon");
         addChild(this._embedTypeImage);
         this._embedText = ComponentFactory.Instance.creat("EquipsTipPanel.embedTxt");
         addChild(this._embedText);
         this._unembedText = ComponentFactory.Instance.creat("EquipsTipPanel.unembedTxt");
         addChild(this._unembedText);
         _height = this._embedHole.height;
      }
      
      private function setData() : void
      {
         var _loc1_:ItemTemplateInfo = null;
         var _loc2_:EquipmentTemplateInfo = null;
         var _loc3_:EquipmentTemplateInfo = null;
         if(this._holeID > 1)
         {
            _loc1_ = ItemManager.Instance.getTemplateById(this._holeID);
            _loc2_ = ItemManager.Instance.getEquipTemplateById(this._holeID);
            if(_loc2_)
            {
               _loc3_ = ItemManager.Instance.getEquipPropertyListById(_loc2_.MainProperty1ID);
               this._embedText.htmlText = LanguageMgr.GetTranslation("ddt.view.tips.embedStoneTip.embedInfo",_loc1_.Property1,_loc3_.PropertyName,_loc2_.MainProperty1Value);
            }
            else
            {
               this._embedText.htmlText = "error";
            }
            this._embedTypeImage.setFrame(this.getFrameIndexByProperID(_loc2_.MainProperty1ID));
            this._embedTypeImage.visible = true;
            this._embedText.visible = true;
            this._unembedText.visible = false;
         }
         else if(this._holeID == 1)
         {
            this._embedHole.setFrame(2);
            this._unembedText.htmlText = LanguageMgr.GetTranslation("ddt.view.tips.embedStoneTip.unEmbed");
            this._embedTypeImage.visible = false;
            this._embedText.visible = false;
            this._unembedText.visible = true;
         }
         else if(this._holeID == -1)
         {
            this._embedHole.setFrame(1);
            this._unembedText.text = LanguageMgr.GetTranslation("ddt.view.tips.embedStoneTip.unOpened");
            this._embedTypeImage.visible = false;
            this._embedText.visible = false;
            this._unembedText.visible = true;
         }
      }
      
      private function getFrameIndexByProperID(param1:int) : int
      {
         switch(param1)
         {
            case 1:
               return 1;
            case 2:
               return 2;
            case 3:
               return 3;
            case 4:
               return 4;
            case 7:
               return 5;
            default:
               return -1;
         }
      }
      
      public function get holeID() : int
      {
         return this._holeID;
      }
      
      public function set holeID(param1:int) : void
      {
         this._holeID = param1;
         this.setData();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeObject(this._embedHole);
         this._embedHole = null;
         ObjectUtils.disposeObject(this._embedTypeImage);
         this._embedTypeImage = null;
         ObjectUtils.disposeObject(this._embedText);
         this._embedText = null;
         ObjectUtils.disposeObject(this._unembedText);
         this._unembedText = null;
      }
   }
}
