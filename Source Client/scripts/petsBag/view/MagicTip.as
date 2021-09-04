package petsBag.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.StringUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PetInfoManager;
   import pet.date.PetInfo;
   
   public class MagicTip extends BaseTip
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _nameTxt:FilterFrameText;
      
      private var _splitImg1:ScaleBitmapImage;
      
      private var _description:FilterFrameText;
      
      private var _splitImg2:ScaleBitmapImage;
      
      private var _resultTxt:FilterFrameText;
      
      private var _container:SimpleTileList;
      
      private var _list:Vector.<FilterFrameText>;
      
      public function MagicTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _loc1_:FilterFrameText = null;
         super.init();
         this._bg = ComponentFactory.Instance.creat("petsBag.view.magicTip.bg");
         _width = this._bg.width;
         _height = this._bg.height;
         addChild(this._bg);
         this._nameTxt = ComponentFactory.Instance.creat("petsBag.view.magicTip.nametxt");
         this._nameTxt.text = LanguageMgr.GetTranslation("petsbag.tips.magicTip.name");
         addChild(this._nameTxt);
         this._splitImg1 = ComponentFactory.Instance.creatComponentByStylename("petsBag.view.magicTip.splitImg1");
         addChild(this._splitImg1);
         this._description = ComponentFactory.Instance.creat("petsBag.view.infoView.descriptionTxt");
         this._description.text = LanguageMgr.GetTranslation("petsbag.tips.magicTip.description");
         addChild(this._description);
         this._splitImg2 = ComponentFactory.Instance.creatComponentByStylename("petsBag.view.magicTip.splitImg2");
         addChild(this._splitImg2);
         this._resultTxt = ComponentFactory.Instance.creat("petsBag.view.infoView.resultTxt");
         this._resultTxt.text = LanguageMgr.GetTranslation("petsbag.tips.magicTip.result");
         addChild(this._resultTxt);
         this._container = ComponentFactory.Instance.creat("petsBag.view.magicTip.listView",[2]);
         this._list = new Vector.<FilterFrameText>();
         this._container.beginChanges();
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            _loc1_ = ComponentFactory.Instance.creat("petsBag.view.infoView.propertyTxt");
            this._list.push(_loc1_);
            this._container.addChild(_loc1_);
            _loc2_++;
         }
         this._container.commitChanges();
         addChild(this._container);
      }
      
      override public function set tipData(param1:Object) : void
      {
         var _loc3_:PetInfo = null;
         var _loc4_:PetInfo = null;
         super.tipData = param1;
         var _loc2_:PetInfo = param1 as PetInfo;
         if(_loc2_)
         {
            _loc3_ = PetInfoManager.instance.getPetInfoByTemplateID(_loc2_.TemplateID);
            _loc4_ = PetInfoManager.instance.getPetInfoByTemplateID(_loc2_.MagicId);
            this._list[0].text = LanguageMgr.GetTranslation("petsBag.view.MagicTip.property0",StringUtils.ljust(String(int((_loc4_.Blood - _loc3_.Blood) / 100)),4),StringUtils.ljust(String(int((_loc4_.Attack - _loc3_.Attack) / 100)),4));
            this._list[1].text = LanguageMgr.GetTranslation("petsBag.view.MagicTip.property1",StringUtils.ljust(String(int((_loc4_.Defence - _loc3_.Defence) / 100)),4),StringUtils.ljust(String(int((_loc4_.Agility - _loc3_.Agility) / 100)),4));
            this._list[2].text = LanguageMgr.GetTranslation("petsBag.view.MagicTip.property2",StringUtils.ljust(String(int((_loc4_.Luck - _loc3_.Luck) / 100)),4));
            this._container.arrange();
         }
      }
   }
}
