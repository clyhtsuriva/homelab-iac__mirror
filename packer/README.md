# Packer Templates

This folder contains Packer templates for creating custom VM images.

# Usage

1. Make sure you have a file called `credentials.pkr.hcl` at the root of packer.
2. Go into a subdirectory corresponding to an image.
3. Validate the packer template.
4. Build the image.

```sh
cd <image subfolder>
packer validate -var-file=../credentials.pkr.hcl ./debian-server-bookworm.pkr.hcl
packer build -var-file=../credentials.pkr.hcl ./debian-server-bookworm.pkr.hcl
```
