// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.buff.buffButton.PreventKickBuffButton

package ddt.view.buff.buffButton
{
    import ddt.data.BuffInfo;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.ShowTipManager;
    import ddt.manager.PlayerManager;
    import ddt.manager.ShopManager;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.LeavePageManager;
    import flash.events.MouseEvent;

    public class PreventKickBuffButton extends BuffButton 
    {

        public function PreventKickBuffButton()
        {
            super("asset.core.pvtKickAsset");
            info = new BuffInfo(BuffInfo.PREVENT_KICK);
        }

        override protected function __onclick(_arg_1:MouseEvent):void
        {
            var _local_2:BaseAlerFrame;
            if (Setting)
            {
                return;
            };
            ShowTipManager.Instance.removeCurrentTip();
            super.__onclick(_arg_1);
            if (PlayerManager.Instance.Self.Money >= ShopManager.Instance.getMoneyShopItemByTemplateID(_info.buffItemInfo.TemplateID).getItemPrice(1).moneyValue)
            {
                if ((!(checkBagLocked())))
                {
                    return;
                };
                if ((!((_info) && (_info.IsExist))))
                {
                    _local_2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaTax.info"), LanguageMgr.GetTranslation("tank.view.buff.preventKick", ShopManager.Instance.getMoneyShopItemByTemplateID(_info.buffItemInfo.TemplateID).getItemPrice(1).moneyValue), "", LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                }
                else
                {
                    _local_2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaTax.info"), LanguageMgr.GetTranslation("tank.view.buff.addPrice", ShopManager.Instance.getMoneyShopItemByTemplateID(_info.buffItemInfo.TemplateID).getItemPrice(1).moneyValue), "", LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                };
                Setting = true;
                _local_2.addEventListener(FrameEvent.RESPONSE, __onBuyResponse);
            }
            else
            {
                LeavePageManager.showFillFrame();
            };
        }


    }
}//package ddt.view.buff.buffButton

