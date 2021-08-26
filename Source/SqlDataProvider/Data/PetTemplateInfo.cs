using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class PetTemplateInfo
    {
        public int ID { set; get; }

        public int TemplateID { set; get; }

        public string Name { set; get; }

        public int KindID { set; get; }

        public string Description { set; get; }

        public string Pic { set; get; }

        public int RareLevel { set; get; }

        public int MP { set; get; }

        public int StarLevel { set; get; }

        public string GameAssetUrl { set; get; }

        public int EvolutionID { set; get; }
        
    }
}
