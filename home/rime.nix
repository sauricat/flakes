{ config, lib, ... }:
{
  home.file = lib.attrsets.mapAttrs' (name: value: 
      lib.attrsets.nameValuePair 
        (".config/ibus/rime/${value}") 
        ({ source = config.lib.file.mkOutOfStoreSymlink ./rime/${value}; })){ 
             dc = "default.custom.yaml";
             kb2 = "key_bindings2.yaml";
             sym = "mysymbols.yaml";
             dpys = "double_pinyin_mspy.schema.yaml";
             cs = "chaizi.schema.yaml"; 
             cd = "chaizi.dict.yaml"; 
             ws = "wugniu.schema.yaml";
             wls = "wugniu_lopha.schema.yaml";
             wld = "wugniu_lopha.dict.yaml";
             ls = "langjin.schema.yaml";
             ld = "langjin.dict.yaml";
           };
  
}
